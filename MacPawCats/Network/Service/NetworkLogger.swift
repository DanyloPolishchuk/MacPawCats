//
//  NetworkLogger.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 21.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation

class NetworkLogger {
    static func log(request: URLRequest) {
        print("_ _ _ START _ _ _")
        defer { print("_ _ _ END _ _ _") }
        
        let urlAbsString = request.url?.absoluteString ?? ""
        let urlComponents = URLComponents(string: urlAbsString)
        let method = request.httpMethod ?? ""
        let path = urlComponents?.path ?? ""
        let query = urlComponents?.query ?? ""
        let host = urlComponents?.host ?? ""
        var log = "\(urlAbsString)\n\(method) \(path)?\(query)\nHOST: \(host)\n"
        for (key,val) in request.allHTTPHeaderFields ?? [:] {
            log += "\(key) : \(val)\n"
        }
        if let bodyData = request.httpBody, let bodyString = String(data: bodyData, encoding: .utf8) {
            log += "\(bodyString)\n"
        }
        print(log)
    }
    
    static func log(response: HTTPURLResponse) {
        print("_ _ _ RESPONSE START _ _ _")
        defer {print("_ _ _ RESPONSE END _ _ _")}
        var log = "\(response.statusCode)\n"
        log += HTTPURLResponse.localizedString(forStatusCode: response.statusCode) + "\n"
        for (key, val) in response.allHeaderFields {
            log += "\(key) : \(val)\n"
        }
        print(log)
    }
    
    static func log(data: Data) {
        print("_ _ _ RESPONSE DATA START _ _ _")
        defer {print("_ _ _ RESPONSE DATA END _ _ _")}
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            print(jsonData)
        } catch {
            print(error)
        }
    }
    
}
