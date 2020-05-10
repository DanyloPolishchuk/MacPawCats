//
//  ImagesViewModel.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 09.05.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation
import UIKit

class ImagesViewModel {
    
    //MARK: - Properties
    //
    let type: ImagesCollectionScreenType
    let pendingOperations = PendingOperations()
    let networkManager = NetworkManager()
    
    var uploadedImages: [ImageShort]?
    var favourites: [Favourite]?
    var votes: [Vote]?
    
    var images: [ImageShort]?
    var imageRecords = [ImageRecord]()
    
    var numberOfSections: Int {
        switch self.type {
        case .All, .Breeds, .Categories:
            return 2
        case .Uploaded, .Favourites, .Votes:
            return 1
        }
    }
      
    //MARK: - inits
    //
    init(type: ImagesCollectionScreenType) {
        self.type = type
    }
    
    //MARK: - collectionView methods
    //
    func getNumberOfItemsInSection(section: Int) -> Int {
        if section == 0 { // section #1 (index 0)
            // profile screen collections have 1 section
            switch self.type {
            case .All, .Breeds, .Categories:
                return 1 // filter cell
            case .Uploaded:
                return uploadedImages?.count ?? 0
            case .Favourites:
                return favourites?.count ?? 0
            case .Votes:
                return votes?.count ?? 0
            }
        }else{ // section #2 (index 1)
            // search screen collections have 2 sections (1st is a section via filter cell)
            switch self.type {
            case .All, .Breeds, .Categories:
                return images?.count ?? 0
            default:
                return 0
            }
        }
    }
    
    func getSizeForItemAt(indexPath: IndexPath, forCollectionView collectionView: UICollectionView) -> CGSize {
        let standartCellSize = CGSize(width: collectionView.frame.width * 0.33, height: collectionView.frame.width * 0.33)
        switch self.type {
        case .All, .Breeds, .Categories:
            if indexPath.section == 0 { // filter cell
                return CGSize(width: collectionView.frame.width, height: collectionView.frame.width * 0.1)
            }else {
                return standartCellSize
            }
        case .Uploaded, .Favourites, .Votes:
            return standartCellSize
        }
    }
    
    //MARK: - Network methods
    //
    private func loadPortionOfImages(completion: @escaping (_ images: [ImageShort]?, _ error: String?) -> Void ) {
        guard let imageSearchType = ImageSearchType(rawValue: self.type.rawValue) else {return} // works only when type is All/Breeds/Categories
        DispatchQueue.global(qos: .utility).async {
            self.networkManager.searchImagesBy(imageSearchType: imageSearchType) { (images, error) in
                if let images = images {
                    completion(images,nil)
                }else{
                    completion(nil,error)
                }
            }
        }
    }
    func reloadDataSource(completion: @escaping (_ error: String?) -> ()) {
        loadPortionOfImages { (images, error) in
            if let images = images {
                self.images = images
                self.imageRecords = images.map{ImageRecord(url: URL(string: $0.url)!)}
                DispatchQueue.main.async {
                    completion(nil)
                }
            }else {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    func loadAdditionalImages(completion: @escaping (_ error: String?) -> ()) {
        loadPortionOfImages { (images, error) in
            if let loadedImages = images {
                let imageRecords = loadedImages.map{ImageRecord(url: URL(string: $0.url)!)}
                if self.images != nil {
                    self.images! += loadedImages
                    self.imageRecords += imageRecords
                }else {
                    self.images = loadedImages
                    self.imageRecords = imageRecords
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
            }else {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    
    //MARK: - Operations management
    //
    func suspendAllOperations(){
        print("suspendAllOperations called")
        pendingOperations.downloadQueue.isSuspended = true
    }
    func resumeAllOperations(){
        print("resumeAllOperations called")
        pendingOperations.downloadQueue.isSuspended = false
    }
    func loadImagesForVisibleItems(collectionView: UICollectionView) {
        print("loadImagesForVisibleItems called")

        let visibleIndexPaths = Set(collectionView.indexPathsForVisibleItems)
        
        let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
        let toCancel = allPendingOperations.subtracting(visibleIndexPaths)
        let toStart = visibleIndexPaths.subtracting(allPendingOperations)
        
        for indexPath in toCancel {
            if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                pendingDownload.cancel()
            }
            pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
        }
        for indexPath in toStart {
            //TODO: refactor so it works with all types
            if let imageShortToDownload = images?[indexPath.row], let url = URL(string: imageShortToDownload.url) {
                let imageRecordToDownload = ImageRecord(url: url)
                startDownload(for: imageRecordToDownload, at: indexPath, collectionView: collectionView)
            }
        }
        
    }
    func startDownload(for imageRecord: ImageRecord, at indexPath: IndexPath, collectionView: UICollectionView) {
        print("startDownload for imageRecord: \(imageRecord), at indexPath: \(indexPath) called")
        guard pendingOperations.downloadsInProgress[indexPath] == nil else {return}
        let downloader = ImageDownloader(imageRecord)
        downloader.completionBlock = {
            if downloader.isCancelled {return}
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                collectionView.reloadItems(at: [indexPath])
            }
        }
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
}
