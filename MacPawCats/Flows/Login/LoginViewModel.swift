//
//  LoginViewModel.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 29.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation

class LoginViewModel: FinishOutput {
    
    var finishFlow: (() -> Void)?
    var userId: String = ""

    func saveUserId(){
        if let data = userId.data(using: .utf8) {
            do {
                try Keychain.set(value: data, account: "sub_id")
            } catch {
                print("couldn't save sub_id")
            }
        }
        finishFlow?()
    }
    
}
