//
//  LaunchInstructor.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 27.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation

fileprivate var onboardingWasShown = false
fileprivate var isLoginCreated = false

enum LaunchInstructor {
    
    case main
    case login
    case onboarding
    
    static func configure(tutorialWasShown: Bool = onboardingWasShown, isAutorized: Bool = isLoginCreated) -> LaunchInstructor {
        switch (tutorialWasShown, isAutorized) {
        case (true,false), (false,false):
            return .login
        case (false, true):
            return .onboarding
        case (true,true):
            return .main
        }
    }
    
}
