//
//  ImageShort.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 20.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation

struct ImageShort: Codable {
    let id: String
    let url: String
    let categories: [Category]?
    let breeds: [Breed]?    
}
