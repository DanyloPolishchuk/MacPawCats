//
//  LoginCoordinator.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 28.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation

final class LoginCoordinator: BaseCoordinator, FinishOutput {
    
    //MARK: - FinishOutput
    //
    var finishFlow: (() -> Void)?
    
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
        self.showLoginViewController()
    }
    
    //MARK: - Show ViewControllers
    //
    private func showLoginViewController(){
        let loginVC = LoginViewController.initFromStoryboard(name: "Login")
        let viewModel = LoginViewModel()
        loginVC.viewModel = viewModel
        viewModel.finishFlow = { [unowned self] in
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    self.finishFlow?()
                }
        self.router.setRootModule(loginVC, hideBar: false)
    }
    
}
