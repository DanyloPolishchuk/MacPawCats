//
//  RoundedButton.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 28.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

@IBDesignable class RoundedButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
}
