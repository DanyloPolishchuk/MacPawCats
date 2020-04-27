//
//  FinishOutput.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 27.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation

protocol FinishOutput {
    var finishFlow: (() -> Void)? {get set}
}
