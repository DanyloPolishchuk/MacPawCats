//
//  BaseCoordinator.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 27.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation

class BaseCoordinator: NSObject, Coordinator {
    
    var childCoordinators = [Coordinator]()
    
    func addDependency(_ coordinator: Coordinator) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
        childCoordinators.append(coordinator)
    }
    func removeDependency(_ coordinator: Coordinator?) {
        guard !childCoordinators.isEmpty, let coordinator = coordinator else {return}
        for (index,value) in childCoordinators.enumerated() {
            if value === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    //MARK: - Coordinator
    //
    func start() {
        start(with: nil)
    }
    func start(with option: DeepLinkOption?) {
    }
}
