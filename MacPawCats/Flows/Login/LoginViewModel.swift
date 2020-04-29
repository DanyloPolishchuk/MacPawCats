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
    
    func saveUserId() {
        let userIdData = Data(from: userId)
        let saveStatus = KeyChain.save(key: "sub_id", data: userIdData)
        print("save status: \(saveStatus)")
        finishFlow?()
    }
    
}
