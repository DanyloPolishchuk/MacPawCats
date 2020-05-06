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
    
    let redVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "red")
    let orangeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "orange")
    let yellowVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "yellow")
    var pageViewControllers: [UIViewController]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        self.pageViewControllers = [
            redVC,
            orangeVC,
            yellowVC
        ]
        let viewControllers = [
            redVC
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
        case orangeVC:
            return redVC
        case yellowVC:
            return orangeVC
        default:
            return nil
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        switch viewController {
        case redVC:
            return orangeVC
        case orangeVC:
            return yellowVC
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
            setViewControllers([redVC],
                               direction: .reverse,
                               animated: true,
                               completion: nil)
        case 1:
            setViewControllers([orangeVC],
                               direction: previousIndex == 0 ? .forward : .reverse,
                               animated: true,
                               completion: nil)
        case 2:
            setViewControllers([yellowVC],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        default:
            break
        }
    }
}
