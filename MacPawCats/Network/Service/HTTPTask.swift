//
//  HTTPTask.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 21.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String:String]

public enum HTTPTask {
    case request
    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)
    case requestParametersAndHeaders(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
    //TODO: add upload task
}
