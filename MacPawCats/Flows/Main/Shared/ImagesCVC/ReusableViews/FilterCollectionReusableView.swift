//
//  FilterCollectionReusableView.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 11.05.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

class FilterCollectionReusableView: UICollectionReusableView {
    
    //MARK: - Properties
    //
    var type: ImagesCollectionScreenType!
    
    //MARK: - Outlets
     //
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    
    //MARK: - Setup methods
    //
    func setup(type: ImagesCollectionScreenType) {
        self.type = type
        switch type {
        case .All:
            setupAllFilterCell()
        case .Breeds:
            setupBreedsFilterCell()
        case .Categories:
            setupCategoriesFilterCell()
        default:
            break
        }
    }
    
    private func setupAllFilterCell(){
        if let type = UserDefaults.standard.string(forKey: allTypeKey) {
            typeButton.setTitle(type, for: .normal)
        }
        if let order = UserDefaults.standard.string(forKey: allOrderKey) {
            orderButton.setTitle(order, for: .normal)
        }
        categoryButton.isHidden = true
    }
    private func setupBreedsFilterCell(){
        if let type = UserDefaults.standard.string(forKey: breedTypeKey) {
            typeButton.setTitle(type, for: .normal)
        }
        if let order = UserDefaults.standard.string(forKey: breedOrderKey) {
            orderButton.setTitle(order, for: .normal)
        }
        if let breedData = UserDefaults.standard.object(forKey: breedKey) as? Data, let breed = try? JSONDecoder().decode(BreedShort.self, from: breedData) {
            categoryButton.setTitle(breed.name, for: .normal)
        }
    }
    private func setupCategoriesFilterCell(){
        if let type = UserDefaults.standard.string(forKey: categoryTypeKey) {
            typeButton.setTitle(type, for: .normal)
        }
        if let order = UserDefaults.standard.string(forKey: categoryOrderKey) {
            orderButton.setTitle(order, for: .normal)
        }
        if let categoryData = UserDefaults.standard.object(forKey: categoryKey) as? Data, let category = try? JSONDecoder().decode(Category.self, from: categoryData) {
            categoryButton.setTitle(category.name, for: .normal)
        }
    }
    
    //MARK: - Actions
    //
    @IBAction func showFilterAction(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name.showFilterScreen, object: self.type.rawValue)
    }
    
}
