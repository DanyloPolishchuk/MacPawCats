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
    
    //MARK: - Outlets
    //
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var upVoteButton: UIButton!
    @IBOutlet weak var downVoteButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    
    //MARK: - Lifecycle methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Setup methods
    //
    private func setupButtons(){
        upVoteButton.imageView?.contentMode = .scaleAspectFill
        downVoteButton.imageView?.contentMode = .scaleAspectFill
        deleteButton.imageView?.contentMode = .scaleAspectFill
        favouriteButton.imageView?.contentMode = .scaleAspectFill
        //TODO: implement additional buttons setup with ting for (up/DownVote & Fav)
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
        return tableView.frame.width + tableView.frame.width * 0.13
    }
}
