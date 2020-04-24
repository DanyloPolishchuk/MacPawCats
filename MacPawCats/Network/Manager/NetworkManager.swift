//
//  NetworkManager.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 21.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation
import UIKit

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

struct NetworkManager {
    
    let router = Router<TheCatApi>()
    
    //MARK: - Breeds & Categories
    //
    func getBreeds(completion: @escaping (_ breeds: [Breed]?, _ error: String?) -> () ) {
        router.request(.breeds) { (data, response, error) in
            
            if error != nil {
                completion(nil, "Check network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let breeds = try JSONDecoder().decode([Breed].self, from: responseData)
                        completion(breeds,nil)
                        
                    } catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil,networkFailureError)
                }
            }
            
        }
    }
    func getCategories(completion: @escaping (_ categories: [Category]?, _ error: String?) -> () ) {
        router.request(.categories) { (data, response, error) in
            
            if error != nil {
                completion(nil, "Check network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let categories = try JSONDecoder().decode([Category].self, from: responseData)
                        completion(categories,nil)
                        
                    } catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil,networkFailureError)
                }
            }
            
        }
    }
    //MARK: - Votes
    //
    func getVotes(subId: String, limit: Int, page: Int = 0, completion: @escaping (_ votes: [Vote]?,_ error: String? ) -> () ) {
        
        router.request(.votes(subId: subId, limit: limit, page: page)) { (data, response, error) in
            
            if error != nil {
                completion(nil, "Check network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let votes = try JSONDecoder().decode([Vote].self, from: responseData)
                        completion(votes,nil)
                        
                    } catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil,networkFailureError)
                }
            }
            
        }
        
    }
    func voteImage(imageId: String, subId: String, value: Int, completion: @escaping (_ error: String?) -> () ) {
        
        router.request(.voteImage(imageId: imageId, subId: subId, value: value)) { (data, response, error) in
            
            if error != nil {
                completion("Check network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    completion(nil)
                case .failure(let networkFailureError):
                    completion(networkFailureError)
                }
            }
            
        }
        
    }
    func deleteVote(voteId: Int, completion: @escaping (_ error: String?) -> () ) {
        
        router.request(.deleteVote(voteId: voteId)) { (data, response, error) in
            
            if error != nil {
                completion("Check network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    completion(nil)
                case .failure(let networkFailureError):
                    completion(networkFailureError)
                }
            }
            
        }
        
    }
    //MARK: - Favourites
    //
    func getFavourites(subId: String, limit: Int, page: Int = 0, completion: @escaping (_ favourites: [Favourite]?, _ error: String? ) -> () ) {
        
        router.request(.favourites(subId: subId, limit: limit, page: page)) { (data, response, error) in
            
            if error != nil {
                completion(nil, "Check network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let favourites = try JSONDecoder().decode([Favourite].self, from: responseData)
                        completion(favourites,nil)
                        
                    } catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil,networkFailureError)
                }
            }

            
        }
        
    }
    func favouriteImage(imageId: String, subId: String, completion: @escaping (_ error: String?) -> () ) {
        
        router.request(.favouriteImage(imageId: imageId, subId: subId)) { (data, response, error) in
            
            if error != nil {
                completion("Check network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    completion(nil)
                case .failure(let networkFailureError):
                    completion(networkFailureError)
                }
            }
            
        }
        
    }
    func deleteFavourite(favouriteId: Int, completion: @escaping (_ error: String? ) -> () ) {
        
        router.request(.deleteFavourite(favouriteId: favouriteId)) { (data, response, error) in
            
            if error != nil {
                completion("Check network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    completion(nil)
                case .failure(let networkFailureError):
                    completion(networkFailureError)
                }
            }
            
        }
        
    }
    //MARK: - Images
    //
    func searchImagesBy(byBreed: Bool, breed: String? = nil, category: Int? = nil, order: Order, limit: Int, page: Int, completion: @escaping (_ images: [ImageShort]?, _ error: String?) -> () ) {
        
        let route: TheCatApi
        if byBreed {
            route = .searchImagesByBreed(breed: breed ?? "", order: order, limit: limit, page: page)
            
        }else {
            route = .searchImagesByCategory(category: category ?? 1, order: order, limit: limit, page: page)
        }
        
        router.request(route) { (data, response, error) in
            
            if error != nil {
                completion(nil, "Check network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let images = try JSONDecoder().decode([ImageShort].self, from: responseData)
                        completion(images,nil)
                        
                    } catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil,networkFailureError)
                }
            }
            
        }
        
    }
    func getUploadedImages(order: Order, limit: Int, page: Int = 0, completion: @escaping (_ images: [ImageShort]?, _ error: String?) -> () ) {
        
        router.request(.uploadedImages(order: order, limit: limit, page: page)) { (data, response, error) in
            
            if error != nil {
                completion(nil, "Check network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let images = try JSONDecoder().decode([ImageShort].self, from: responseData)
                        completion(images,nil)
                        
                    } catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil,networkFailureError)
                }
            }
            
        }
        
    }
    func uploadImage(image: UIImage, subId: String, completion: @escaping (_ error: String?) -> () ) {
        
        router.request(.uploadImage(image: image, subId: subId)) { (data, response, error) in
            
            if error != nil {
                completion("Check network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    completion(nil)
                case .failure(let networkFailureError):
                    completion(networkFailureError)
                }
            }
            
        }
        
    }
    func getImage(imageId: String, completion: @escaping (_ image: ImageShort?, _ error: String?) -> () ) {
        
        router.request(.image(imageId: imageId)) { (data, response, error) in
            
            if error != nil {
                completion(nil, "Check network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let image = try JSONDecoder().decode(ImageShort.self, from: responseData)
                        completion(image,nil)
                        
                    } catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil,networkFailureError)
                }
            }
            
        }
        
    }
    func deleteImage(imageId: String, completion: @escaping (_ error: String?) -> () ) {
        
        router.request(.deleteImage(imageId: imageId)) { (data, response, error) in
            
            if error != nil {
                completion("Check network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    completion(nil)
                case .failure(let networkFailureError):
                    completion(networkFailureError)
                }
            }
            
        }
        
    }
    func getImageAnalysis(imageId: String, completion: @escaping (_ imageAnalysis: ImageAnalysis?, _ error: String?) -> () ) {
        
        router.request(.imageAnalysis(imageId: imageId)) { (data, response, error) in
            
            if error != nil {
                completion(nil, "Check network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let imageAnalysis = try JSONDecoder().decode(ImageAnalysis.self, from: responseData)
                        completion(imageAnalysis,nil)
                        
                    } catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil,networkFailureError)
                }
            }
            
        }
        
    }
    
    //MARK: - General
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
}
