//
//  OnboardingViewController.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 30.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

//TODO: setup proper images animation
//TODO: implement page Scrolling 

class OnboardingViewController: UIViewController, StoryboardInitializable, FinishOutput {
    
    var finishFlow: (() -> Void)?

    //MARK: - Outlets
    //
    @IBOutlet weak var arrowUpImageView: UIImageView!
    @IBOutlet weak var arrowDownImageView: UIImageView!
    @IBOutlet weak var saveImageVIew: UIImageView!
    @IBOutlet weak var searchImageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //MARK: - Lifecycle methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
    }
    
    //MARK: - Setup methods
    //
    private func setupScrollView(){
        scrollView.delegate = self
        print("scrollView size: \(self.scrollView.frame)")
        print("contentSize: \(self.scrollView.contentSize)")
    }
    
    //MARK: - Animation methods
    //
    
    //MARK: - Actions
    //
    @IBAction func continueAction(_ sender: UIButton) {
        sender.isEnabled = false
        self.finishFlow?()
    }
    
}

//MARK: - UIScrollViewDelegate
//
extension OnboardingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(round(scrollView.contentOffset.x / self.scrollView.frame.width))
        self.pageControl.currentPage = index
        print("contentOffset.x: \(scrollView.contentOffset.x)")
    }
}
