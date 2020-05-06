//
//  CatsFeedViewController.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 05.05.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

protocol FeedToPagesProtocol: class {
    func segmentSelected(index: Int, previousSegmentIndex: Int)
}

class CatsFeedViewController: UIViewController, StoryboardInitializable {
    
    //MARK: - Properties
    //
    var previousIndex: Int?
    var currentIndex: Int?
    var feedToPagesDelegate: FeedToPagesProtocol?
    
    //MARK: - Outlets
    //
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //MARK: - Lifecycle methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        previousIndex = -1
        currentIndex = segmentedControl.selectedSegmentIndex
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? FeedsPageViewController
        feedToPagesDelegate = destinationVC
        destinationVC?.pagesToFeedDelegate = self
    }
    
    //MARK: - Actions
    //
    @IBAction func didSelectSegmentAction(_ sender: UISegmentedControl) {
        previousIndex = currentIndex
        currentIndex = sender.selectedSegmentIndex
        guard let previousIndex = previousIndex, let currentIndex = currentIndex else {return}
        feedToPagesDelegate?.segmentSelected(index: currentIndex, previousSegmentIndex: previousIndex)
    }
}

//MARK: - PagesToFeedProtocol
//
extension CatsFeedViewController: PagesToFeedProtocol {
    func selectSegment(index: Int) {
        previousIndex = currentIndex
        currentIndex = index
        segmentedControl.selectedSegmentIndex = index
    }
}
