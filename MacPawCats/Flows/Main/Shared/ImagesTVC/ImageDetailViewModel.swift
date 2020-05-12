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
    let networkManager = NetworkManager()
    
    //MARK: - inits
    //
    init(type: ImageDetailType) {
        self.type = type
    }
    
    //MARK: - Network methods
    //
    
    // getFull image
    // upVote
    //downVote
    //deleteVote
    //Fav
    //deleteFav
    //deleteUploadedImage

    //TODO: delete
    let tmpID = 1
    
    //MARK: Votes
    //
    func upVote(completion: @escaping (_ error: String?) -> ()) {
        DispatchQueue.global(qos: .utility).async {
            self.networkManager.voteImage(imageId: "\(self.tmpID)", value: 1) { (error) in
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    func downVote(completion: @escaping (_ error: String?) -> ()) {
        DispatchQueue.global(qos: .utility).async {
            self.networkManager.voteImage(imageId: "\(self.tmpID)", value: 0) { (error) in
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    func deleteVote(completion: @escaping (_ error: String?) -> ()) {
        DispatchQueue.global(qos: .utility).async {
            self.networkManager.deleteVote(voteId: self.tmpID) { (error) in
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    //MARK: Favs
    //
    
    //MARK: Other
    //
    func loadImageFrom(url: URL, completion: @escaping (_ image: UIImage?) -> () ) {
        DispatchQueue.global(qos: .utility).async {
            if let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
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
