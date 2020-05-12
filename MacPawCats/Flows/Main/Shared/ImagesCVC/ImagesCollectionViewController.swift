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
    let filterReusableViewIdentifier = "FilterCollectionReusableViewReuseIdentifier"
    let additionalLoadingReusableViewIdentifier = "AdditionalLoadingCollectionReusableViewReuseIdentifier"
    let imageCellIdentifier = "ImageCollectionViewCellIdentifier"
    
    var loadingView: UIView?
    var footerView: AdditionalLoadingCollectionReusableView?
    var viewModel: ImagesViewModel!

    //MARK: - Lifecycle methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        setupNofitications()
        
        // initial load
        setupInitialLoadingView()
        viewModel.loadAdditionalImages { (error) in
            self.removeInitialLoadingView()
            self.handleResponse(error: error)
        }
    }
    
    //MARK: - Setup methods
    //
    private func setupRefreshControl(){
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    private func setupInitialLoadingView(){
        loadingView = UIView(frame: self.view.frame)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.center = loadingView?.center ?? CGPoint.zero
        loadingView?.addSubview(activityIndicator)
        self.view.addSubview(loadingView ?? UIView())
    }
    private func removeInitialLoadingView(){
        UIView.animate(withDuration: 0.5, animations: {
            self.loadingView?.alpha = 0
        }) { (animationsFinishedBeforeCompletion) in
            self.loadingView?.removeFromSuperview()
        }
    }
    private func setupNofitications(){
        let name: Notification.Name
        switch viewModel.type {
        case .All:
            name = Notification.Name.reloadAllImagesScreenDataSource
        case .Breeds:
            name = Notification.Name.reloadBreedImagesScreenDataSource
        case .Categories:
            name = Notification.Name.reloadCategoryImagesScreenDataSource
        default:
            name = Notification.Name.reloadAllImagesScreenDataSource
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefresh), name: name, object: nil)
    }
    
    //MARK: - Response Alert methods
    //
    func handleResponse(error: String?) {
        if let error = error {
            presentAlertFor(error: error)
            return
        }
        self.collectionView.refreshControl?.endRefreshing()
        self.collectionView.reloadData()
    }
    func presentAlertFor(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel) )
        self.present(alert, animated: true)
    }
    
    //MARK: - @objc methods
    //
    @objc func handleRefresh() {
        viewModel.reloadDataSource { (error) in
            self.handleResponse(error: error)
        }
    }
    
    
    // MARK: - UICollectionViewDataSource
    //
    
    //MARK: item methods
    //
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfItems()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellIdentifier, for: indexPath) as! ImageCollectionViewCell
        let imageRecord = viewModel.imageRecords[indexPath.item]
        cell.setupCell(imageRecord: imageRecord)
        if !collectionView.isDragging && !collectionView.isDecelerating, imageRecord.state == .new {
            viewModel.startDownload(for: imageRecord, at: indexPath, collectionView: collectionView)
        }
        return cell
            
    }
    
    //MARK: supplementaryView methods
    //
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: filterReusableViewIdentifier, for: indexPath) as! FilterCollectionReusableView
            headerView.setup(type: viewModel.type)
            return headerView
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: additionalLoadingReusableViewIdentifier, for: indexPath) as! AdditionalLoadingCollectionReusableView
            self.footerView = footerView
            return footerView
        default:
            return UICollectionReusableView()
        }
    }
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.startAnimating()
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.stopAnimating()
        }
    }
    
    //MARK: - UICollectionViewDelegate
    //
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.getNumberOfItems() - 1 {
            viewModel.loadAdditionalImages { (error) in
                self.handleResponse(error: error)
            }
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // if imageCell -> detailPresentationCallback to coordinator
        print("didSelectItemAt indexPath: \(indexPath)")
    }
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
            cell.highlight()
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
            cell.unHighLight()
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
    
    func scrollToTop(){
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
//
extension ImagesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if (viewModel.type == .All || viewModel.type == .Breeds || viewModel.type == .Categories) {
            return CGSize(width: collectionView.frame.width, height: 55)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.33, height: collectionView.frame.width * 0.33)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.viewModel.isLoading {
            return CGSize.zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}
