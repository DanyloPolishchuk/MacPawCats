//
//  FilterViewModel.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 12.05.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation

class FilterViewModel {
    
    //MARK: - Properties
    //
    let type: ImageSearchType
    
    // values from UD
    let categories: [Category]
    let breedsShort: [BreedShort]
    let breed: BreedShort
    let category: Category
    let allType: String
    let breedType: String
    let categoryType: String
    let allOrder: String
    let breedOrder: String
    let categoryOrder: String
    // enum arrs
    let imageTypeStrings = [ImageType.all.rawValue, ImageType.png.rawValue, ImageType.jpg.rawValue]
    let orderStrings = [Order.random.rawValue, Order.descending.rawValue, Order.ascending.rawValue]
    
    var currentBreed: BreedShort
    var currentCategory: Category
    var currentType: String
    var currentOrder: String
    
    //MARK: - init
    //
    init(type: ImageSearchType) {
        self.type = type
        
        let decoder = JSONDecoder()
        let defaultOrderString = "RAND"
        let defaultImageTypeString = "jpg,png"
        
        if let categoriesData = UserDefaults.standard.data(forKey: categoriesKey), let categories = try? decoder.decode([Category].self, from: categoriesData) {
            self.categories = categories
        } else {self.categories = [Category]()}
        if let breedsData = UserDefaults.standard.data(forKey: breedsKey), let breedsShort = try? decoder.decode([BreedShort].self, from: breedsData) {
            self.breedsShort = breedsShort
        } else {self.breedsShort = [BreedShort]()}
        
        if let breedData = UserDefaults.standard.data(forKey: breedKey), let breed = try? JSONDecoder().decode(BreedShort.self, from: breedData) {
            self.breed = breed
        }else {self.breed = BreedShort(id: "abys", name: "Abyssinian")}
        if let categoryData = UserDefaults.standard.data(forKey: categoryKey), let category = try? JSONDecoder().decode(Category.self, from: categoryData) {
            self.category = category
        }else {self.category = Category(id: 1, name: "hats")}
        
        self.allType = UserDefaults.standard.string(forKey: allTypeKey) ?? defaultImageTypeString
        self.breedType = UserDefaults.standard.string(forKey: breedTypeKey) ?? defaultImageTypeString
        self.categoryType = UserDefaults.standard.string(forKey: categoryTypeKey) ?? defaultImageTypeString

        self.allOrder = UserDefaults.standard.string(forKey: allOrderKey) ?? defaultOrderString
        self.breedOrder = UserDefaults.standard.string(forKey: breedOrderKey) ?? defaultOrderString
        self.categoryOrder = UserDefaults.standard.string(forKey: categoryOrderKey) ?? defaultOrderString
                
        self.currentBreed = self.breed
        self.currentCategory = self.category
        switch type {
        case .All:
            self.currentType = self.allType
            self.currentOrder = self.allOrder
        case .Breeds:
            self.currentType = self.breedType
            self.currentOrder = self.breedOrder
        case .Categories:
            self.currentType = self.categoryType
            self.currentOrder = self.categoryOrder
            
        }
    }
    
    //MARK: - PickerView protocol methods
    //
    func numberOfComponents() -> Int {
        switch type {
        case .All:
            return 2
        case .Breeds, .Categories:
            return 3
        }
    }
    func numberOfRowsIn(component: Int) -> Int {
        switch type {
        case .All:
            return 3
        case .Breeds:
            if component == 0 {
                return breedsShort.count
            }else {
                return 3
            }
        case .Categories:
            if component == 0 {
                return categories.count
            }else {
                return 3
            }
        }
    }
    func titleFor(row: Int, component: Int) -> String {
        switch type {
        case .All:
            if component == 0 {
                return orderStrings[row]
            }else {
                return imageTypeStrings[row]
            }
        case .Breeds:
            if component == 0 {
                return breedsShort[row].name
            }else if component == 1 {
                return orderStrings[row]
            }else {
                return imageTypeStrings[row]
            }
        case .Categories:
            if component == 0 {
                return categories[row].name
            }else if component == 1 {
                return orderStrings[row]
            }else {
                return imageTypeStrings[row]
            }
        }
    }
    func didSelect(row: Int, inComponent component: Int){
        switch type {
        case .All:
            if component == 0 {
                currentOrder = orderStrings[row]
            }else {
                currentType = imageTypeStrings[row]
            }
        case .Breeds:
            if component == 0 {
                currentBreed = breedsShort[row]
            }else if component == 1 {
                currentOrder = orderStrings[row]
            }else {
                currentType = imageTypeStrings[row]
            }
        case .Categories:
            if component == 0 {
                currentCategory = categories[row]
            }else if component == 1 {
                currentOrder = orderStrings[row]
            }else {
                currentType = imageTypeStrings[row]
            }
        }
    }
    
    func getDefaultSelectedIndexPaths() -> [IndexPath] {
        var res = [IndexPath]()
        switch type {
        case .All:
            res.append(IndexPath(row: orderStrings.firstIndex(of: allOrder) ?? 0, section: 0))
            res.append(IndexPath(row: imageTypeStrings.firstIndex(of: allType) ?? 0, section: 1))
        case .Breeds:
            res.append(IndexPath(row: breedsShort.firstIndex(where: {$0.name == breed.name}) ?? 0, section: 0))
            res.append(IndexPath(row: orderStrings.firstIndex(of: breedOrder) ?? 0, section: 1))
            res.append(IndexPath(row: imageTypeStrings.firstIndex(of: breedType) ?? 0, section: 2))
        case .Categories:
            res.append(IndexPath(row: categories.firstIndex(where: {$0.name == category.name}) ?? 0, section: 0))
            res.append(IndexPath(row: orderStrings.firstIndex(of: categoryOrder) ?? 0, section: 1))
            res.append(IndexPath(row: imageTypeStrings.firstIndex(of: categoryType) ?? 0, section: 2))
        }
        return res
    }
    
    func saveChanges(completion: @escaping () -> ()) {
        switch type {
        case .All:
            if currentOrder != allOrder || currentType != allType {
                UserDefaults.standard.set(currentType, forKey: allTypeKey)
                UserDefaults.standard.set(currentOrder, forKey: allOrderKey)
                NotificationCenter.default.post(name: Notification.Name.reloadAllImagesScreenDataSource, object: nil)
                completion()
            }
        case .Breeds:
            if currentOrder != breedOrder || currentType != breedType || currentBreed.id != breed.id {
                UserDefaults.standard.set(currentType, forKey: breedTypeKey)
                UserDefaults.standard.set(currentOrder, forKey: breedOrderKey)
                if let currentBreedData = try? JSONEncoder().encode(currentBreed) {
                    UserDefaults.standard.set(currentBreedData, forKey: breedKey)
                }
                NotificationCenter.default.post(name: Notification.Name.reloadBreedImagesScreenDataSource, object: nil)
                completion()
            }
        case .Categories:
            if currentOrder != categoryOrder || currentType != categoryType || currentCategory.id != category.id {
                UserDefaults.standard.set(currentType, forKey: categoryTypeKey)
                UserDefaults.standard.set(currentOrder, forKey: categoryOrderKey)
                if let currentCategoryData = try? JSONEncoder().encode(currentCategory) {
                    UserDefaults.standard.set(currentCategoryData, forKey: categoryKey)
                }
                NotificationCenter.default.post(name: Notification.Name.reloadCategoryImagesScreenDataSource, object: nil)
                completion()
            }
        }
    }
    
}
