//
//  NetworkAccessibilityCoordinator.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 17.05.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation
import UIKit

final class NetworkAccessibilityCoordinator: BaseCoordinator {
    
    private let router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    override func start() {
        self.showNetworkAccessibilityScreen()
    }
    
    private func showNetworkAccessibilityScreen(){
        let networkAccessibilityVC = UIStoryboard(name: "NetworkAccessibility", bundle: nil).instantiateInitialViewController()
        self.router.setRootModule(networkAccessibilityVC)
    }
}
