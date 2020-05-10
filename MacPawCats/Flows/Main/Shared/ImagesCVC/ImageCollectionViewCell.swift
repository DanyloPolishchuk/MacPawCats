//
//  ImageCollectionViewCell.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 09.05.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    //
    var type: ImagesCollectionScreenType!
    
    //MARK: - Outlets
    //
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var darkenerView: UIView!
    @IBOutlet weak var favouriteStatusImageView: UIImageView!
    @IBOutlet weak var voteStatusImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func setupCell(imageRecord: ImageRecord) {
        self.imageView.image = imageRecord.image
        switch imageRecord.state {
        case .downloaded, .failed:
            darkenerView.alpha = 0
            activityIndicator.stopAnimating()
        case .new:
            darkenerView.alpha = 0.2
            activityIndicator.startAnimating()
        }
        //TODO: implement   (up/downvote, fav, (optionally later uploaded)) imageView(s) isHidden and image properties setup
        favouriteStatusImageView.isHidden = true
        voteStatusImageView.isHidden = true
    }
    
}
