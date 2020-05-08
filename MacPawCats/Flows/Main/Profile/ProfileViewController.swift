//
//  ProfileViewController.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 08.05.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

protocol ProfileViewControllerProtocol: class {
    var onDidSelectUploadedImages: ((_ arr: [ImageShort])->Void)? {get set}
    var onDidSelectFavourites: ((_ arr: [Favourite])->Void)? {get set}
    var onDidSelectVotes: ((_ arr: [Vote])->Void)? {get set}
}

class ProfileViewController: UIViewController, StoryboardInitializable, ProfileViewControllerProtocol {

    //MARK: - Properties
    //
    var viewModel: ProfileViewModel!
    
    var onDidSelectUploadedImages: (([ImageShort]) -> Void)?
    var onDidSelectFavourites: (([Favourite]) -> Void)?
    var onDidSelectVotes: (([Vote]) -> Void)?
    
    
    //MARK: - Outlets
    //
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    
    //MARK: - Lifecycle methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        userIdLabel.text = viewModel.getUserId()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        
        viewModel.getUploadedImagesCount {
            self.tableView.reloadData()
        }
        viewModel.getFavouritesCount {
            self.tableView.reloadData()
        }
        viewModel.getVotesCount {
            self.tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDataSource
//
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "imagesCellIdentifier", for: indexPath)
        if cell.accessoryView == nil {
            let indicatorView = UIActivityIndicatorView(style: .medium)
            cell.accessoryView = indicatorView
            viewModel.counts[indexPath.row] == nil ? indicatorView.startAnimating() : indicatorView.stopAnimating()
        }
        
        switch indexPath.row {
        case 0: // uploaded
            cell.imageView?.image = UIImage(systemName: "square.and.arrow.up")
            cell.textLabel?.text = "Uploaded images"
        case 1: // favourited
            cell.imageView?.image = UIImage(systemName: "bookmark.fill")
            cell.textLabel?.text = "Favourited images"
        case 2: // votes
            cell.imageView?.image = UIImage(systemName: "arrow.up.square.fill")
            cell.textLabel?.text = "Voted images"
        default:
            break
        }
        cell.detailTextLabel?.text = "\(viewModel.counts[indexPath.row] ?? 0)"
        cell.imageView?.tintColor = UIColor.systemGreen
        
        return cell
        
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            onDidSelectUploadedImages?(viewModel.uploadedImages)
        case 1:
            onDidSelectFavourites?(viewModel.favouritedImages)
        case 2:
            onDidSelectVotes?(viewModel.votes)
        default:
            break
        }
    }
}
