//
//  CatImageUploadViewModel.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 04.05.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation
import UIKit

class CatImageUploadViewModel {
    
    private let networkManager = NetworkManager()
    var image = UIImage()
    
    func uploadImage(completion: @escaping (_ responseSring: String) -> () ) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            self.networkManager.uploadImage(image: self.image) { (error) in
                let responseString = error == nil ? "Image've been successfully uploaded" : error!
                DispatchQueue.main.async {
                    completion(responseString)
                }
            }
        }
    }
    
}
