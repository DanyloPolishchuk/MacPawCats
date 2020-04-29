//
//  AppCoordinator.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 27.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation

final class AppCoordinator: BaseCoordinator {
    
    private let router: RouterProtocol
    private var launchInstructor = LaunchInstructor.configure()
    
    init(router: Router) {
        self.router = router
    }
    
    override func start(with option: DeepLinkOption?) {
        if option != nil {
            
        } else {
            switch launchInstructor {
            case .login: runLoginFlow()
            case .onboarding: runOnboardingFlow()
            case .main: runMainFlow()
            }
        }
    }
    
    //MARK: - Flows
    //
    private func runLoginFlow(){
        print("runLoginFlow called")
        let loginCoordinator = LoginCoordinator(router: self.router)
        loginCoordinator.finishFlow = { [unowned self, unowned loginCoordinator] in
            self.removeDependency(loginCoordinator)
            self.launchInstructor = LaunchInstructor.configure()
            self.start()
        }
        self.addDependency(loginCoordinator)
        loginCoordinator.start()
    }
    private func runOnboardingFlow(){
        print("runOnboardingFlow called")
    }
    private func runMainFlow(){
        print("runMainFlow called")
    }
    
}
