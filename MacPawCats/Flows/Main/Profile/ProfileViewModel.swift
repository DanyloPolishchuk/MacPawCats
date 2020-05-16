//
//  ProfileViewModel.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 08.05.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation

class ProfileViewModel {
    
    private let networkManager = NetworkManager()
    
    var uploadedImages = [ImageShort]()
    var favouritedImages = [Favourite]()
    var counts: [Int?] = [nil, nil]
    
    func getUserId() -> String {
        return self.networkManager.subId
    }
    
    func resetCounts(){
        self.counts = [nil, nil]
    }
    
    func getUploadedImagesCount(completion: @escaping () -> () ) {
        DispatchQueue.global(qos: .utility).async {
            
            self.networkManager.getUploadedImages { (images, error) in
                if let images = images {
                    self.uploadedImages = images
                }
                let count = images?.count ?? 0
                self.counts[0] = count
                DispatchQueue.main.async {
                    completion()
                }
            }
            
        }
    }
    
    func getFavouritesCount(completion: @escaping () -> () ) {
        DispatchQueue.global(qos: .utility).async {
            self.networkManager.getFavourites { (favourites, error) in
                if let favourites = favourites {
                    self.favouritedImages = favourites
                }
                let count = favourites?.count ?? 0
                self.counts[1] = count
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
}
