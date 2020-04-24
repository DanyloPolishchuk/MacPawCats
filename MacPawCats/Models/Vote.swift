//
//  Vote.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 20.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation

struct Vote: Codable {
    let value: Int
    let image_id: String
    let sub_id: String?
    let created_at: String?
    let id: Int?
    let country_code: String?
}
