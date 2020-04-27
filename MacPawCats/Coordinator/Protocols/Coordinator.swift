//
//  Coordinator.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 27.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation

protocol Coordinator: class {
    func start()
    func start(with option: DeepLinkOption?)
}
