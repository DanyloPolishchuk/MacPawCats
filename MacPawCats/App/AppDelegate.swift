//
//  AppDelegate.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 20.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit
import CoreData
import Network

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootController: UINavigationController {
        return self.window?.rootViewController as! UINavigationController
    }
    private lazy var appCoordinator: Coordinator = AppCoordinator(router: Router(rootController: self.rootController))
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupCategoriesAndBreeds()
        setupDefaultFilterParameters()
        setupNetworkChecker()
//        appCoordinator.start(with: nil)
        return true
    }
    
    //MARK: - Setup methods
    //
    func setupCategoriesAndBreeds(){
        let areDefaultKeysSaved = UserDefaults.standard.bool(forKey: areDefaultKeysSavedKey)
        let networkManager = NetworkManager()
        networkManager.getCategories { (categories, error) in
            if let categories = categories, let categoriesData = try? JSONEncoder().encode(categories) {
                UserDefaults.standard.set(categoriesData, forKey: categoriesKey)
                if let defaultCategory = categories.first, let defaultCategoryData = try? JSONEncoder().encode(defaultCategory) {
                    if !areDefaultKeysSaved {
                        UserDefaults.standard.set(defaultCategoryData, forKey: categoryKey)
                    }
                }
            }
        }
        networkManager.getBreeds { (breeds, error) in
            if let breedsShort = breeds?.map({ BreedShort(id: $0.id, name: $0.name) }), let breedsShortData = try? JSONEncoder().encode(breedsShort) {
                UserDefaults.standard.set(breedsShortData, forKey: breedsKey)
                if let defaultBreed = breedsShort.first, let defaultBreedData = try? JSONEncoder().encode(defaultBreed) {
                    if !areDefaultKeysSaved {
                        UserDefaults.standard.set(defaultBreedData, forKey: breedKey)
                    }
                }
            }
        }
    }
    func setupDefaultFilterParameters(){
        let areDefaultKeysSaved = UserDefaults.standard.bool(forKey: areDefaultKeysSavedKey)
        if areDefaultKeysSaved {
            return
        }else {
            UserDefaults.standard.set(ImageType.all.rawValue, forKey: allTypeKey)
            UserDefaults.standard.set(ImageType.all.rawValue, forKey: breedTypeKey)
            UserDefaults.standard.set(ImageType.all.rawValue, forKey: categoryTypeKey)
            
            UserDefaults.standard.set(Order.random.rawValue, forKey: allOrderKey)
            UserDefaults.standard.set(Order.random.rawValue, forKey: breedOrderKey)
            UserDefaults.standard.set(Order.random.rawValue, forKey: categoryOrderKey)
            
            UserDefaults.standard.set(true, forKey: areDefaultKeysSavedKey)
        }
    }
    
    //MARK: - Network availability checker
    //
    func setupNetworkChecker(){
        let pathMonitor = NWPathMonitor()
        pathMonitor.pathUpdateHandler = { path in
            switch path.status {
            case .requiresConnection, .unsatisfied:
                DispatchQueue.main.async {
                    self.appCoordinator.start(with: .networkAccessibilityScreen)
                }
            default:
                DispatchQueue.main.async {
                    self.appCoordinator.start(with: nil)
                }
            }
        }
        let queue = DispatchQueue.global()
        pathMonitor.start(queue: queue)
    }

}

