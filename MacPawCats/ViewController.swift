//
//  ViewController.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 20.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func startRequestsAction(_ sender: UIButton) {
        
        // breeds + categories
        
//        NetworkManager().getCategories { (categories, error) in
//            guard let categories = categories else {
//                print(error)
//                return
//            }
//            print(categories)
//        }
//
//        NetworkManager().getBreeds { (breeds, error) in
//            guard let breeds = breeds else {
//                print(error)
//                return
//            }
//            print(breeds)
//        }
        
        // votes
        
//        NetworkManager().getVotes(subId: "MacPawCatsTestUser1", limit: 9) { (votes, error) in
//            guard let votes = votes else {
//                print(error)
//                return
//            }
//            print(votes)
//        }
        
//        NetworkManager().voteImage(imageId: "vH0bd0YDH", subId: "MacPawCatsTestUser1", value: 1) { (error) in
//            guard error != nil else {
//                print("voteImage success")
//                return
//            }
//            print(error)
//        }

        
//        NetworkManager().deleteVote(voteId: 187178) { (error) in
//            guard error != nil else {
//                print("deleteVote success")
//                return
//            }
//            print(error)
//        }
        
        // favourites
        
//        NetworkManager().getFavourites(subId: "MacPawCatsTestUser1", limit: 9) { (favourites, error) in
//            guard let favourites = favourites else {
//                print(error)
//                return
//            }
//            print(favourites)
//        }
        
//        NetworkManager().favouriteImage(imageId: "r_njVlaSz", subId: "MacPawCatsTestUser1") { (error) in
//            guard error != nil else {
//                print("favouriteImage success")
//                return
//            }
//            print(error)
//        }
        
//        NetworkManager().deleteFavourite(favouriteId: 2017674) { (error) in
//            guard error != nil else {
//                print("deleteFavourite success")
//                return
//            }
//            print(error)
//        }
        
        // images
        
//        NetworkManager().searchImagesBy(byBreed: false, category: 1, order: Order.descending, limit: 9, page: 0) { (images, error) in
//            guard let images = images else {
//                print(error)
//                return
//            }
//            print(images)
//        }
        
//        NetworkManager().getUploadedImages(order: Order.descending, limit: 9, page: 0) { (images, error) in
//            guard let images = images else {
//                print(error)
//                return
//            }
//            print(images)
//        }
//
        NetworkManager().uploadImage(image: UIImage(named: "fixel")!, subId: "MacPawCatsTestUser1") { (error) in
            guard error != nil else {
                print("uploadImage success")
                return
            }
            print(error)
        }
        
        /*
         {
             "id": "PBJGmSLn6",
             "url": "https://cdn2.thecatapi.com/images/PBJGmSLn6.jpg",
             "sub_id": "MacPawCatsTestUser1",
             "width": 1920,
             "height": 1272,
             "original_filename": "fixel.jpg",
             "pending": 0,
             "approved": 1
         }
         */
        
//
//        NetworkManager().getImage(imageId: "7js") { (image, error) in
//            guard let image = image else {
//                print(error)
//                return
//            }
//            print(image)
//        }
//
//        NetworkManager().deleteImage(imageId: "") { (error) in
//            guard error != nil else {
//                print("deleteImage success")
//                return
//            }
//            print(error)
//        }
//
//        NetworkManager().getImageAnalysis(imageId: "") { (imageAnalysis, error) in
//            guard let imageAnalysis = imageAnalysis else {
//                print(error)
//                return
//            }
//            print(imageAnalysis)
//        }
        
    }
    
    var upvote = true
    @IBAction func sen2ndRequest(_ sender: Any) {
//        NetworkManager().voteImage(imageId: "vH0bd0YDH", subId: "MacPawCatsTestUser1", value: upvote ? 1 : 0) { (error) in
//            guard error != nil else {
//                print("voteImage success")
//                self.upvote.toggle()
//                return
//            }
//            print(error)
//        }
    }
}

