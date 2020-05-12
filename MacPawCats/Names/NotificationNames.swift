//
//  NotificationNames.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 12.05.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    // NotificationKey
    
    static let showFilterScreen = Notification.Name("showFilterScreenNotificationKey")
    static let showDetailScreen = Notification.Name("showDetailScreenNotificationKey")
    static let reloadAllImagesScreenDataSource = Notification.Name("reloadAllImagesScreenDataSourceNotificationKey")
    static let reloadBreedImagesScreenDataSource = Notification.Name("reloadBreedImagesScreenDataSourceNotificationKey")
    static let reloadCategoryImagesScreenDataSource = Notification.Name("reloadCategoryImagesScreenDataSourceNotificationKey")


}
