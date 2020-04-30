//
//  OnboardingViewController.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 30.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

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
    
    @IBOutlet weak var cell1View: UIView!
    
    @IBOutlet weak var upVoteConstraint: NSLayoutConstraint!
    @IBOutlet weak var downVoteConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchConstraint: NSLayoutConstraint!
    
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
    }
    
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
    }
}
