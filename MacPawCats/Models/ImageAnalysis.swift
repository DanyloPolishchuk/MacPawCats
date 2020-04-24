//
//  ImageAnalysis.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 20.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation

struct ImageAnalysis: Codable {
    let image_id: String
    let labels: [ModerationLabel]
    let modLabels: [ModerationLabel]
    let vendor: String
    let approved: Bool
    let rejected: Bool
}
