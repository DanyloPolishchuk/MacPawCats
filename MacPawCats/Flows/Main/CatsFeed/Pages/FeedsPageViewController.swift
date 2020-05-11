//
//  FeedsPageViewController.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 05.05.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

protocol PagesToFeedProtocol: class {
    func selectSegment(index: Int)
}

class FeedsPageViewController: UIPageViewController {

    
    //MARK: - Properties
    //
    private var currentIndex = 0
    private var previousIndex = 0
    
    weak var pagesToFeedDelegate: PagesToFeedProtocol?
    
    let allImagesCollectionViewController = ImagesCollectionViewController.initFromStoryboard()
    let breedsCollectionViewController = ImagesCollectionViewController.initFromStoryboard()
    let categoriesCollectionViewController = ImagesCollectionViewController.initFromStoryboard()
    var pageViewControllers: [UIViewController]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        allImagesCollectionViewController.viewModel = ImagesViewModel(type: .All)
        breedsCollectionViewController.viewModel = ImagesViewModel(type: .Breeds)
        categoriesCollectionViewController.viewModel = ImagesViewModel(type: .Categories)
        
        self.pageViewControllers = [
            allImagesCollectionViewController,
            breedsCollectionViewController,
            categoriesCollectionViewController
        ]
        let viewControllers = [
            allImagesCollectionViewController
        ]
        setViewControllers(viewControllers,
                           direction: .forward,
                           animated: true,
                           completion: nil)
    }

}

extension FeedsPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        switch viewController {
        case breedsCollectionViewController:
            return allImagesCollectionViewController
        case categoriesCollectionViewController:
            return breedsCollectionViewController
        default:
            return nil
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        switch viewController {
        case allImagesCollectionViewController:
            return breedsCollectionViewController
        case breedsCollectionViewController:
            return categoriesCollectionViewController
        default:
            return nil
        }
    }
}

extension FeedsPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
                
        guard let currentVC = viewControllers?.first,
        let index = pageViewControllers?.firstIndex(of: currentVC) else {return}
        previousIndex = currentIndex
        currentIndex = index
        pagesToFeedDelegate?.selectSegment(index: index)
        
    }
}

//MARK: - FeedToPagesProtocol
//
extension FeedsPageViewController: FeedToPagesProtocol {
    func segmentSelected(index: Int, previousSegmentIndex: Int) {
        
        self.currentIndex = index
        self.previousIndex = previousSegmentIndex
        
        switch index {
        case 0:
            setViewControllers([allImagesCollectionViewController],
                               direction: .reverse,
                               animated: true,
                               completion: nil)
        case 1:
            setViewControllers([breedsCollectionViewController],
                               direction: previousIndex == 0 ? .forward : .reverse,
                               animated: true,
                               completion: nil)
        case 2:
            setViewControllers([categoriesCollectionViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        default:
            break
        }
    }
    func scrollToTop() {
        switch currentIndex {
        case 0:
            allImagesCollectionViewController.scrollToTop()
        case 1:
            breedsCollectionViewController.scrollToTop()
        case 2:
            categoriesCollectionViewController.scrollToTop()
        default:
            break
        }
    }
}
