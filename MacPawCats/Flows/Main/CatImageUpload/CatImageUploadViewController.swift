//
//  CatImageUploadViewController.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 04.05.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

class CatImageUploadViewController: UIViewController, StoryboardInitializable {

    //MARK: - Properties
    //
    var viewModel: CatImageUploadViewModel!
    
    //MARK: - Outlets
    //
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addButton: RoundedButton!
    @IBOutlet weak var uploadButton: RoundedButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var completionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Setup methods
    //
    private func setupUI(){
        imageView.layer.cornerRadius = 10
        completionLabel.isHidden = true
        uploadButton.isEnabled = false
        activityIndicator.isHidden = true
    }
    
    //MARK: - ActionSheet methods
    //
    private func showActionSheet(){
        let alertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.showCameraPickerView()
        }))
        alertController.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.showGalleryPickerView()
        }))
        alertController.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        self.present(alertController, animated: true, completion: nil)
    }
    private func showCameraPickerView(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

    }
    private func showGalleryPickerView(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Actions
    //
    @IBAction func addImageAction(_ sender: UIButton) {
        showActionSheet()
    }
    @IBAction func uploadImageAction(_ sender: UIButton) {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        sender.isEnabled = false
        addButton.isEnabled = false
        
        viewModel.uploadImage { (responseString) in
            self.completionLabel.isHidden = false
            self.completionLabel.text = responseString
            
            self.activityIndicator.stopAnimating()
            
            sender.isEnabled = true
            self.addButton.isEnabled = true
            
        }
    }
    
}

//MARK: - UIImagePickerControllerDelegate
//
extension CatImageUploadViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            viewModel.image = pickedImage
            imageView.image = pickedImage
        }
        picker.dismiss(animated: true) {
            self.uploadButton.isEnabled = true
        }
    }
}

//MARK: - UINavigationControllerDelegate
//
extension CatImageUploadViewController: UINavigationControllerDelegate {
}
