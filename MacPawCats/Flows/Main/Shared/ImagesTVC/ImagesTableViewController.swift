//
//  ImagesTableViewController.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 12.05.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

// currently works only as a static detailTableViewController for 1 "image"
class ImagesTableViewController: UITableViewController, StoryboardInitializable {
    
    //MARK: - Properties
    //
    var viewModel: ImageDetailViewModel!
    let animationDuration = 0.25
    
    //MARK: - Outlets
    //
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var upVoteButton: UIButton!
    @IBOutlet weak var downVoteButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    
    @IBOutlet weak var upVoteButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var downVoteButtonConstraint: NSLayoutConstraint!
    
    //MARK: - Lifecycle methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupImage()
    }
    
    //MARK: - Setup methods
    //
    private func setupButtons(){
        deleteButton.isHidden = !viewModel.isUploaded
        favouriteButton.isHidden = viewModel.isFav
        favouriteButton.tintColor = viewModel.isFav ? UIColor.systemGreen : UIColor.darkGray
    }
    private func setupImage(){
        imageView.image = viewModel.imageRecord.image
        if viewModel.imageRecord.state != .downloaded {
            activityIndicator.startAnimating()
            viewModel.loadImage { (image) in
                self.activityIndicator.stopAnimating()
                if let image = image {
                    self.imageView.image = image
                }else {
                    self.presentAlertFor(error: "Couldn't load image")
                }
            }
        }else {activityIndicator.stopAnimating()}
    }
    
    //MARK: - Alert methods
    //
    func presentAlertFor(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel) )
        self.present(alert, animated: true)
    }

    // MARK: - Table view data source / delegate methods
    //
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width + (viewModel.type == .image ? tableView.frame.width * 0.13 : 0)
    }
    
    //MARK: - Animation methods
    //
    private func animateUpVote(){
        UIView.animate(withDuration: animationDuration, animations: {
            self.upVoteButtonConstraint.constant  = -10
            self.upVoteButton.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            self.view.layoutIfNeeded()
        }) { (finished) in
            UIView.animate(withDuration: self.animationDuration) {
                self.upVoteButtonConstraint.constant  = 0
                self.upVoteButton.transform = .identity
                self.view.layoutIfNeeded()
            }
        }
    }
    private func animateDownVote(){
        UIView.animate(withDuration: animationDuration, animations: {
            self.downVoteButtonConstraint.constant = 10
            self.downVoteButton.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            self.view.layoutIfNeeded()
        }) { (finished) in
            UIView.animate(withDuration: self.animationDuration) {
                self.downVoteButtonConstraint.constant = 0
                self.downVoteButton.transform = .identity
                self.view.layoutIfNeeded()
            }
        }
    }
    private func animateFav(){
        favouriteButton.tintColor = UIColor.systemGreen
        favouriteButton.setBackgroundImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        UIView.animate(withDuration: animationDuration) {
            self.favouriteButton.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            self.view.layoutIfNeeded()
        }
    }
    private func resetFav(){
        favouriteButton.tintColor = UIColor.darkGray
        favouriteButton.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
        UIView.animate(withDuration: animationDuration) {
            self.favouriteButton.transform = CGAffineTransform(scaleX: 0.625, y: 0.625)
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Actions
    //
    @IBAction func upVoteAction(_ sender: UIButton) {
        downVoteButton.tintColor = UIColor.darkGray
        upVoteButton.tintColor = UIColor.systemGreen
        animateUpVote()
        viewModel.upVote { (error) in
            if let error = error {
                self.presentAlertFor(error: error)
            }
        }
    }
    @IBAction func downVoteAction(_ sender: UIButton) {
        upVoteButton.tintColor = UIColor.darkGray
        downVoteButton.tintColor = UIColor.systemRed
        animateDownVote()
        viewModel.downVote { (error) in
            if let error = error {
                self.presentAlertFor(error: error)
            }
        }
    }
    @IBAction func deleteAction(_ sender: UIButton) {
        viewModel.deleteImage { (error) in
            if let error = error {
                self.presentAlertFor(error: error)
            }
        }
    }
    @IBAction func favouriteAction(_ sender: UIButton) {
        guard !viewModel.isFav else {return}
        animateFav()
        viewModel.favourite { (error) in
            if let error = error {
                self.presentAlertFor(error: error)
                self.resetFav()
            }
        }
    }
    
}
