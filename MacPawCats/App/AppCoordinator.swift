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
    private let launchInstructor = LaunchInstructor.configure()
    
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
        
    }
    private func runOnboardingFlow(){
        
    }
    private func runMainFlow(){
        
    }
    
}
