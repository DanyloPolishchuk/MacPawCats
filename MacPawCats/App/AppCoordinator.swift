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
    private var networkAccessibilityCoordinator: NetworkAccessibilityCoordinator?
    
    init(router: Router) {
        self.router = router
    }
    
    override func start(with option: DeepLinkOption?) {
        if option != nil {
            switch option {
            case .networkAccessibilityScreen:
                runNetworkAccessibilityFlow()
            default:
                break
            }
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
        let onboardingCoordinator = OnboardingCoordinator(router: self.router)
        onboardingCoordinator.finishFlow = { [unowned self, unowned onboardingCoordinator] in
            self.removeDependency(onboardingCoordinator)
            self.launchInstructor = LaunchInstructor.configure()
            self.start()
        }
        self.addDependency(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    private func runMainFlow(){
        self.removeDependency(networkAccessibilityCoordinator)
        let mainCoordinator = MainCoordinator(router: self.router)
        self.addDependency(mainCoordinator)
        mainCoordinator.start()
    }
    private func runNetworkAccessibilityFlow(){
        networkAccessibilityCoordinator = NetworkAccessibilityCoordinator(router: self.router)
        self.addDependency(networkAccessibilityCoordinator as! Coordinator)
        networkAccessibilityCoordinator?.start()
    }
    
}
