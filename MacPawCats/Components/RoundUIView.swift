//
//  RoundUIView.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 17.05.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

@IBDesignable class RoundUIView: UIView {
    @IBInspectable var isRound: Bool = false {
        didSet {
            self.layer.cornerRadius = isRound ? self.frame.width / 2 : 0
        }
    }
}
