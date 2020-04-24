//
//  EndPoint.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 21.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL {get}
    var path: String {get}
    var httpMethod: HTTPMethod {get}
    var task: HTTPTask {get}
    var headers: HTTPHeaders? {get}
}
