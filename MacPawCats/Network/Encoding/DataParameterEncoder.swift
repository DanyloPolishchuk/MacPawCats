//
//  DataParameterEncoder.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 23.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation
import UIKit

public struct DataParameterEncoder: ParameterEncoder {
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            
            let boundary = "Boundary-\(UUID().uuidString)"
            var data = Data()
            
            for parameter in parameters {
                let paramName = parameter.key
                data.append("--\(boundary)\r\n".data(using: .utf8)!)
                data.append("Content-Disposition:form-data; name=\"\(paramName)\";".data(using: .utf8)!)
                if let stringValue = parameter.value as? String {
                    data.append("\r\n\r\n\(stringValue)\r\n".data(using: .utf8)!)
                } else if let imageValue = parameter.value as? UIImage {
                    let fileName = "testImageName"
                    let imageData = imageValue.pngData()!
                    data.append("filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
                    data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
                    data.append(imageData)
                    
                }
            }
            
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

            urlRequest.setValue("3773ba5d-d4e7-4f9b-b9b3-a8e5cb13bc8a", forHTTPHeaderField: "x-api-key")
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = data
            
        } catch {
            throw NetworkError.encodingFailed
        }
    }
}
