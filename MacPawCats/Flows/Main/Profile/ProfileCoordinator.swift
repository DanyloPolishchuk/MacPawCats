//
//  ProfileCoordinator.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 03.05.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation

final class ProfileCoordinator: BaseCoordinator {
    
    //MARK: - Properties
    //
    private let router: RouterProtocol
    
    //MARK: - inits
    //
    init(router: RouterProtocol) {
        self.router = router
    }
    
    //MARK: - Coordinator
    //
    override func start() {
        showProfileScreen()
    }
    
    func showProfileScreen(){
        let profileVC = ProfileViewController.initFromStoryboard()
        profileVC.viewModel = ProfileViewModel()
        profileVC.onDidSelectUploadedImages = { images in
            self.showUploadedImagesScreen(images)
        }
        profileVC.onDidSelectFavourites = { favourites in
            self.showFavouritesScreen(favourites)
        }
        profileVC.onDidSelectVotes = { votes in
            self.showVotesScreen(votes)
        }
        self.router.push(profileVC)
    }
    
    func showUploadedImagesScreen(_ uploadedImages: [ImageShort]) {
        print("showUploadedImagesScreen")
    }
    func showFavouritesScreen(_ favourites: [Favourite]) {
        print("showFavouritesScreen")
    }
    func showVotesScreen(_ votes: [Vote]) {
        print("showVotesScreen")
    }
    
}
