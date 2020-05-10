//
//  ImageOperations.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 10.05.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation
import UIKit

//MARK: - imageDownloading classes
//
enum ImageState {
    case new
    case downloaded
    case failed
}

class ImageRecord {
    let url: URL
    var state = ImageState.new
    var image = UIImage(named: "Placeholder")
    
    init(url: URL) {
        self.url = url
    }
}

class PendingOperations {
    lazy var downloadsInProgress: [IndexPath:Operation] = [:]
    lazy var downloadQueue = OperationQueue()
}

class ImageDownloader: Operation {
    let imageRecord: ImageRecord
    init(_ imageRecord: ImageRecord) {
        self.imageRecord = imageRecord
    }
    override func main() {
        if isCancelled {return}
        guard let imageData = try? Data(contentsOf: imageRecord.url) else {return}
        if isCancelled {return}
        if !imageData.isEmpty {
            imageRecord.image = UIImage(data: imageData)
            imageRecord.state = .downloaded
        }else {
            imageRecord.image = UIImage(named: "Failed")
            imageRecord.state = .failed
        }
    }
}
