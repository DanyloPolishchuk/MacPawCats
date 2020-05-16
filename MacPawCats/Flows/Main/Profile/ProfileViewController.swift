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
}

class ProfileViewController: UIViewController, StoryboardInitializable, ProfileViewControllerProtocol {

    //MARK: - Properties
    //
    var viewModel: ProfileViewModel!
    
    var onDidSelectUploadedImages: (([ImageShort]) -> Void)?
    var onDidSelectFavourites: (([Favourite]) -> Void)?
    
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
        tableView.allowsSelection = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        clearOnAppear()
        
        viewModel.resetCounts()
        viewModel.getUploadedImagesCount {
            self.tableView.reloadData()
            self.tableView.allowsSelection = true
        }
        viewModel.getFavouritesCount {
            self.tableView.reloadData()
            self.tableView.allowsSelection = true
        }
    }
    
    private func clearOnAppear(){
        for indexPath in tableView.indexPathsForSelectedRows ?? [] {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

//MARK: - UITableViewDataSource
//
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
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
            cell.imageView?.image = UIImage(systemName: "square.and.arrow.up.fill")
            cell.textLabel?.text = "Uploaded images"
        case 1: // favourited
            cell.imageView?.image = UIImage(systemName: "bookmark.fill")
            cell.textLabel?.text = "Favourited images"
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
        guard viewModel.counts[indexPath.row] != nil else {return}
        switch indexPath.row {
        case 0:
            onDidSelectUploadedImages?(viewModel.uploadedImages)
        case 1:
            onDidSelectFavourites?(viewModel.favouritedImages)
        default:
            break
        }
    }
}
