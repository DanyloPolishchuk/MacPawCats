//
//  CatImageUploadCoordinator.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 03.05.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation

final class CatImageUploadCoordinator: BaseCoordinator {
    
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
        showImageUploadScreen()
    }
    
    private func showImageUploadScreen(){
        let uploadVC = CatImageUploadViewController.initFromStoryboard()
        let viewModel = CatImageUploadViewModel()
        uploadVC.viewModel = viewModel
        self.router.push(uploadVC)
    }
}
