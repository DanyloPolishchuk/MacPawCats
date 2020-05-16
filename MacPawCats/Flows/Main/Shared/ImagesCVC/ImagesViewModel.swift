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
    var isLoading = false // first load / reload
    
    let type: ImagesCollectionScreenType
    let isFeed: Bool
    
    let pendingOperations = PendingOperations()
    let networkManager = NetworkManager()
    
    var uploadedImages: [ImageShort]?
    var favourites: [Favourite]?
    var votes: [Vote]?
    
    var images: [ImageShort]?
    var imageRecords = [ImageRecord]()
    
      
    //MARK: - inits
    //
    init(type: ImagesCollectionScreenType) {
        self.type = type
        self.isFeed = type == .All || type == .Breeds || type == .Categories
    }
    init(uploadedImages: [ImageShort]) {
        self.type = ImagesCollectionScreenType.Uploaded
        self.isFeed = false
        self.uploadedImages = uploadedImages
        self.imageRecords = uploadedImages.map{ImageRecord(url: URL(string: $0.url)!)}
    }
    init(favourites: [Favourite]) {
        self.type = ImagesCollectionScreenType.Favourites
        self.isFeed = false
        self.favourites = favourites
        self.imageRecords = favourites.map{ImageRecord(url: URL(string: $0.image.url)!)}
    }
    
    //MARK: - collectionView methods
    //
    func getNumberOfItems() -> Int {
        switch self.type {
        case .Uploaded:
            return uploadedImages?.count ?? 0
        case .Favourites:
            return favourites?.count ?? 0
        case .Votes:
            return votes?.count ?? 0
        default:
            return images?.count ?? 0
        }
    }
    func getTitle() -> String? {
        return type.rawValue
    }
        
    //MARK: - Network methods
    //
    private func loadPortionOfImages(completion: @escaping (_ images: [ImageShort]?, _ error: String?) -> Void ) {
        guard !self.isLoading else {return}
        guard let imageSearchType = ImageSearchType(rawValue: self.type.rawValue) else {return} // works only when type is All/Breeds/Categories
        DispatchQueue.global(qos: .utility).async {
            self.isLoading = true
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
                self.isLoading = false
                DispatchQueue.main.async {
                    completion(nil)
                }
            }else {
                self.isLoading = false
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
                self.isLoading = false
                DispatchQueue.main.async {
                    completion(nil)
                }
            }else {
                self.isLoading = false
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    
    //MARK: - Operations management
    //
    func suspendAllOperations(){
        pendingOperations.downloadQueue.isSuspended = true
    }
    func resumeAllOperations(){
        pendingOperations.downloadQueue.isSuspended = false
    }
    func loadImagesForVisibleItems(collectionView: UICollectionView) {

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
