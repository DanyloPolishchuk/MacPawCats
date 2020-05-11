//
//  CatsFeedCoordinator.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 03.05.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation

final class CatsFeedCoordinator: BaseCoordinator {
    
    //MARK: - Properties
    //
    private let router: RouterProtocol
    var feedVC: CatsFeedViewController!
    
    //MARK: - inits
    //
    init(router: RouterProtocol) {
        self.router = router
    }
    
    //MARK: - Coordinator
    //
    override func start() {
        showCatsFeedScreen()
    }
    
    func scrollToTop(){
        feedVC.scrollToTop()
    }
    
    private func showCatsFeedScreen(){
        feedVC = CatsFeedViewController.initFromStoryboard()
        self.router.push(feedVC)
    }
    
}
