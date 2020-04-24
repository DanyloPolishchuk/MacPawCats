//
//  Breed.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 20.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation

struct Breed: Codable {
    
    let id: String
    let name: String
    let temperament: String
    let life_span: String
    let alt_names: String
    let wikipedia_url: String
    let origin: String
    let weight: Weight
    let country_code: String
    
    let experimental: Int
    let hairless: Int
    let natural: Int
    let rare: Int
    let rex: Int
    let suppressed_tail: Int
    let short_legs: Int
    let hypoallergenic: Int
    
    let adaprability: Int
    let affectionLevel: Int
    let child_friendly: Int
    let dog_friendly: Int
    let energy_level: Int
    let grooming: Int
    let health_issues: Int
    let intelligence: Int
    let shedding_level: Int
    let social_needs: Int
    let stranger_friendly: Int
    let vocalisation: Int
}
