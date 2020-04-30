//
//  OnboardingCoordinator.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 30.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation

final class OnboardingCoordinator: BaseCoordinator, FinishOutput {

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
        self.showOnboardingViewController()
    }
    
    //MARK: - Show ViewControllers
    //
    private func showOnboardingViewController(){
        let onboardingVC = OnboardingViewController.initFromStoryboard(name: "Onboarding")
        onboardingVC.finishFlow = { [unowned self] in
            UserDefaults.standard.set(true, forKey: "isOnboardingShown")
            self.finishFlow?()
        }
        self.router.setRootModule(onboardingVC, hideBar: true)
    }
    
}
