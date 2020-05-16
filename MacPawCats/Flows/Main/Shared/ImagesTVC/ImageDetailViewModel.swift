//
//  ImageDetailViewModel.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 12.05.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation
import UIKit

enum ImageDetailType {
    case upload
    case favourite
    case vote
    case image
}

class ImageDetailViewModel {
    
    //MARK: - Properties
    //
    var type: ImageDetailType
    let imageId: String
    let imageRecord: ImageRecord
    var isFav: Bool
    let isUploaded: Bool
    
    let networkManager = NetworkManager()
    
    //MARK: - inits
    //
    init(type: ImageDetailType, imageId: String, imageRecord: ImageRecord) {
        self.type = type
        self.imageId = imageId
        self.imageRecord = imageRecord
        self.isFav = type == .favourite
        self.isUploaded = type == .upload
    }
    
    //MARK: - Network methods
    //
    
    //MARK: Votes
    //
    func upVote(completion: @escaping (_ error: String?) -> ()) {
        DispatchQueue.global(qos: .utility).async {
            self.networkManager.voteImage(imageId: self.imageId, value: 1) { (error) in
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    func downVote(completion: @escaping (_ error: String?) -> ()) {
        DispatchQueue.global(qos: .utility).async {
            self.networkManager.voteImage(imageId: self.imageId, value: 0) { (error) in
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    //MARK: Favs
    //
    func favourite(completion: @escaping (_ error: String?) -> ()){
        DispatchQueue.global(qos: .utility).async {
            self.networkManager.favouriteImage(imageId: self.imageId) { (error) in
                DispatchQueue.main.async {
                    if error == nil {
                        self.isFav = true
                    }
                    completion(error)
                }
            }
        }
    }
    
    //MARK: Image
    //
    func deleteImage(completion: @escaping (_ error: String?) -> ()) {
        DispatchQueue.global(qos: .utility).async {
            self.networkManager.deleteImage(imageId: self.imageId) { (error) in
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    //MARK: Other
    //
    func loadImage(completion: @escaping (_ image: UIImage?) -> () ) {
        DispatchQueue.global(qos: .utility).async {
            if let imageData = try? Data(contentsOf: self.imageRecord.url), let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }else{
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
}
