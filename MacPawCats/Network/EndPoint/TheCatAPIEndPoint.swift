//
//  TheCatAPIEndPoint.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 22.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation
import UIKit

public enum Order: String {
    case random = "RAND"
    case descending = "DESC"
    case ascending = "ASC"
}

public enum TheCatApi {
    
    // breeds
    case breeds
    
    // categories
    case categories
    
    // votes
    case votes(subId: String, limit: Int, page: Int)
    case voteImage(imageId: String, subId: String, value: Int)
    case deleteVote(voteId: Int)
    
    // favourites
    case favourites(subId: String, limit: Int, page: Int)
    case favouriteImage(imageId: String, subId: String)
    case deleteFavourite(favouriteId: Int)
    
    // images
    case searchImagesByBreed(breed: String, order: Order, limit: Int, page: Int)
    case searchImagesByCategory(category: Int, order: Order, limit: Int, page: Int)
    case uploadedImages(order: Order, limit: Int, page: Int)
    case uploadImage(image: UIImage, subId: String)
    case image(imageId: String)
    case deleteImage(imageId: String)
    case imageAnalysis(imageId: String)
    
}

extension TheCatApi: EndPointType {
    
    var baseURL: URL {
        guard let url = URL(string: "https://api.thecatapi.com/v1/") else {fatalError("can't setup base url")}
        return url
    }
    
    var path: String {
        switch self {
            // breeds
        case .breeds:
            return "breeds"
            // categories
        case .categories:
            return "categories"
            // votes
        case .votes, .voteImage:
            return "votes"
        case .deleteVote(voteId: let voteId):
            return "votes/\(voteId)"
            // favourites
        case .favourites, .favouriteImage:
            return "favourites"
        case .deleteFavourite(favouriteId: let favouriteId):
            return "favourites/\(favouriteId)"
            // images
        case .searchImagesByBreed, .searchImagesByCategory:
            return "images/search"
        case .uploadedImages:
            return "images"
        case .uploadImage:
            return "images/upload"
        case .image(imageId: let imageId), .deleteImage(imageId: let imageId):
            return "images/\(imageId)"
        case .imageAnalysis(imageId: let imageId):
            return "images/\(imageId)/analysis"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
            // breeds
        case .breeds:
            return .get
            // categories
        case .categories:
            return .get
            // votes
        case .votes:
            return .get
        case .voteImage:
            return .post
        case .deleteVote:
            return .delete
            // favourites
        case .favourites:
            return .get
        case .favouriteImage:
            return .post
        case .deleteFavourite:
            return .delete
            // images
        case .searchImagesByBreed, .searchImagesByCategory:
            return .get
        case .uploadedImages:
            return .get
        case .uploadImage:
            return .post
        case .image:
            return .get
        case .deleteImage:
            return .delete
        case .imageAnalysis:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
            
            // breeds & categories
        case .breeds, .categories:
            return .request
            
            // votes
        case .votes(subId: let subId, limit: let limit, page: let page):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["sub_id" : subId,
                                                      "limit" : limit,
                                                      "page" : page])
        case .voteImage(imageId: let imageId, subId: let subId, value: let value):
            return .requestParameters(bodyParameters: ["image_id":imageId,
                                                       "sub_id":subId,
                                                       "value":value],
                                      bodyEncoding: .jsonEncoding,
                                      urlParameters: nil)
        case .deleteVote:
            return .request
            
            // favourites
        case .favourites(subId: let subId, limit: let limit, page: let page):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["sub_id" : subId,
                                                      "limit" : limit,
                                                      "page" : page])
        case .favouriteImage(imageId: let imageId, subId: let subId):
            return .requestParameters(bodyParameters: ["image_id":imageId,
                                                       "sub_id":subId],
                                      bodyEncoding: .jsonEncoding,
                                      urlParameters: nil)
        case .deleteFavourite:
            return .request
            
        // images
        case .searchImagesByBreed(breed: let breed, order: let order, limit: let limit, page: let page):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["breed_ids":breed,
                                                      "order": order.rawValue,
                                                      "limit":limit,
                                                      "page":page])
        case .searchImagesByCategory(category: let category, order: let order, limit: let limit, page: let page):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["category_ids":category,
                                                      "order": order.rawValue,
                                                      "limit":limit,
                                                      "page":page])
        case .uploadedImages(order: let order, limit: let limit, page: let page):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["order": order.rawValue,
                                                      "limit":limit,
                                                      "page":page])
        case .uploadImage(image: let image, subId: let subId):
            return .requestParameters(bodyParameters: ["file":image,
                                                       "sub_id":subId],
                                      bodyEncoding: .dataEncoding,
                                      urlParameters: nil)
        case .image, .deleteImage, .imageAnalysis:
            return .request
            
        }
    }
    
    var headers: HTTPHeaders? {
        return ["x-api-key":"3773ba5d-d4e7-4f9b-b9b3-a8e5cb13bc8a"]
    }
    
}
