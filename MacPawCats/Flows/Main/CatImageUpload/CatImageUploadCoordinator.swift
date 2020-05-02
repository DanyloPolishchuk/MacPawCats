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
        // push image upload screen
        print("CatImageUploadCoordinator start called")
    }
}
