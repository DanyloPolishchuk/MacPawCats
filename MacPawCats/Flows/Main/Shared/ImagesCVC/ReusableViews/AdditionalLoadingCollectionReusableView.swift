//
//  AdditionalLoadingCollectionReusableView.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 11.05.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

class AdditionalLoadingCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func startAnimating(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    func stopAnimating(){
        activityIndicator.stopAnimating()
    }
}
