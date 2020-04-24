//
//  ImageFull.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 20.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation

struct ImageFull: Codable {
    let id: String
    let url: String
    let sub_id: String
    let created_at: String
    let original_fileName: String
    let categories: [Category]
    let breeds: [Breed]
}
