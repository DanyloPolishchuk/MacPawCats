//
//  Favourite.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 20.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation

struct Favourite: Codable {
    let id: Int
    let image_id: String
    let sub_id: String
    let created_at: String
    let user_id: String
    let image: ImageShort
}

