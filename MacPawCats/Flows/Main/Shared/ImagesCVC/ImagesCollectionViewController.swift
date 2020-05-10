//
//  ImagesCollectionViewController.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 09.05.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

enum ImagesCollectionScreenType: String {
    case All
    case Breeds
    case Categories
    case Uploaded
    case Favourites
    case Votes
}

class ImagesCollectionViewController: UICollectionViewController, StoryboardInitializable {
    
    //MARK: - Properties
    //
    let filterCellIdentifier = "FilterCollectionViewCellIndentifier"
    let imageCellIdentifier = "ImageCollectionViewCellIdentifier"
    var viewModel: ImagesViewModel!

    //MARK: - Lifecycle methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        viewModel.loadAdditionalImages { (error) in
            if let error = error {
                //TODO: display error alert
                return
            }
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - Setup methods
    //
    private func setupRefreshControl(){
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    //MARK: - @objc methods
    //
    @objc func handleRefresh() {
        viewModel.reloadDataSource { (error) in
            if let error = error {
                //TODO: display error alert
                return
            }
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    
    // MARK: - UICollectionViewDataSource
    //
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfItemsInSection(section: section)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        if (viewModel.type == .All || viewModel.type == .Breeds || viewModel.type == .Categories) && indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterCellIdentifier, for: indexPath) as! FilterCollectionViewCell
            cell.setupCell(type: viewModel.type)
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellIdentifier, for: indexPath) as! ImageCollectionViewCell
            let imageRecord = viewModel.imageRecords[indexPath.item]
            cell.setupCell(imageRecord: imageRecord)
            if !collectionView.isDragging && !collectionView.isDecelerating, imageRecord.state == .new {
                viewModel.startDownload(for: imageRecord, at: indexPath, collectionView: collectionView)
            }
            return cell
        }
            
    }
    
    //MARK: - UIScrollViewDelegate
    //
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        viewModel.suspendAllOperations()
    }
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            viewModel.loadImagesForVisibleItems(collectionView: collectionView)
            viewModel.resumeAllOperations()
        }
    }
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.loadImagesForVisibleItems(collectionView: collectionView)
        viewModel.resumeAllOperations()
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
//
extension ImagesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.getSizeForItemAt(indexPath: indexPath, forCollectionView: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
