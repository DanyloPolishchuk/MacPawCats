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
    
    let router = NetworkRouter<TheCatApi>()
    let subId: String
    
    //MARK: - inits
    //
    init() {
        do {
            if let subIdData = try Keychain.get(account: "sub_id"), let subId = String(data: subIdData, encoding: .utf8) {
                self.subId = subId
            } else{
                self.subId = "MacPawTestUser1"
            }
        } catch {
            self.subId = "MacPawTestUser1"
        }
    }
    
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
    func getVotes(completion: @escaping (_ votes: [Vote]?, _ error: String? ) -> () ) {
        
        router.request(.votes(subId: self.subId, limit: nil, page: nil)) { (data, response, error) in
            
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
                        completion(votes, nil)
                        
                    } catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
            
        }
        
    }
    func voteImage(imageId: String, value: Int, completion: @escaping (_ error: String?) -> () ) {
        
        router.request(.voteImage(imageId: imageId, subId: self.subId, value: value)) { (data, response, error) in
            
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
    func getFavourites(completion: @escaping (_ favourites: [Favourite]?, _ error: String? ) -> () ) {
        
        router.request(.favourites(subId: self.subId, limit: nil, page: nil)) { (data, response, error) in
            
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
                        completion(favourites, nil)
                        
                    } catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }

            
        }
        
    }
    func favouriteImage(imageId: String, completion: @escaping (_ error: String?) -> () ) {
        
        router.request(.favouriteImage(imageId: imageId, subId: self.subId)) { (data, response, error) in
            
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
    func searchImagesBy(imageSearchType: ImageSearchType, completion: @escaping (_ images: [ImageShort]?, _ error: String?) -> () ) {
        
        let route: TheCatApi
        let limit = 12
        let defaultOrderString = "RAND"
        let defaultImageTypeString = "jpg,png"
        
        switch imageSearchType {
            
        case .All:
            let allOrder = Order(rawValue: UserDefaults.standard.string(forKey: allOrderKey) ?? defaultOrderString)
            let allImageType = ImageType(rawValue: UserDefaults.standard.string(forKey: allTypeKey) ?? defaultImageTypeString)
            route = .searchImages(order: allOrder ?? Order.random, imageType: allImageType ?? ImageType.all, limit: limit)
            
        case .Breeds:
            let breedOrder = Order(rawValue: UserDefaults.standard.string(forKey: breedOrderKey) ?? defaultOrderString)
            let breedImageType = ImageType(rawValue: UserDefaults.standard.string(forKey: breedTypeKey) ?? defaultImageTypeString)
            let breedString: String
            if let breedData = UserDefaults.standard.data(forKey: breedKey), let breed = try? JSONDecoder().decode(BreedShort.self, from: breedData) {
                breedString = breed.id
            }else{
                breedString = "beng"
            }
            route = .searchImagesByBreed(breed: breedString, order: breedOrder ?? Order.random, imageType: breedImageType ?? ImageType.all, limit: limit, page: nil)
            
        case .Categories:
            let categoryOrder = Order(rawValue: UserDefaults.standard.string(forKey: categoryOrderKey) ?? defaultOrderString)
            let categoryImageType = ImageType(rawValue: UserDefaults.standard.string(forKey: categoryTypeKey) ?? defaultImageTypeString)
            let categoryNum: Int
            if let categoryData = UserDefaults.standard.data(forKey: categoryKey), let category = try? JSONDecoder().decode(Category.self, from: categoryData) {
                categoryNum = category.id
            }else{
                categoryNum = 1
            }
            route = .searchImagesByCategory(category: categoryNum, order: categoryOrder ?? Order.random, imageType: categoryImageType ?? ImageType.all, limit: limit, page: nil)
            
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
    func getUploadedImages(completion: @escaping (_ images: [ImageShort]?, _ error: String?) -> () ) {
        
        router.request(.uploadedImages(order: nil, limit: nil, page: nil, subId: self.subId)) { (data, response, error) in
            
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
                        completion(images, nil)
                        
                    } catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
            
        }
        
    }
    func uploadImage(image: UIImage, completion: @escaping (_ error: String?) -> () ) {
        
        router.request(.uploadImage(image: image, subId: self.subId)) { (data, response, error) in
            
            if error != nil {
                completion("Check network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    completion(nil)
                case .failure:
                    completion(HTTPURLResponse.localizedString(forStatusCode: response.statusCode).capitalized)
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
