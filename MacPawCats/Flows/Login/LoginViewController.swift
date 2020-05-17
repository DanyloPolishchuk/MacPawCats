//
//  LoginViewController.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 28.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit
import AudioToolbox

class LoginViewController: UIViewController, StoryboardInitializable {
    
    //MARK: - Properties
    //
    var viewModel: LoginViewModel!
    
    //MARK: - Outlets
    //
    @IBOutlet weak var userIdImageView: UIImageView!
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var userIdErrorsLabel: UILabel!
    @IBOutlet weak var createUserButton: RoundedButton!
    @IBOutlet weak var userCreatedImageView: UIImageView!
    
    //MARK: - Lifecycle methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Setup methods
    //
    func setupUI(){
        userIdErrorsLabel.isHidden = true
        createUserButton.isEnabled = false
        userCreatedImageView.alpha = 0.0
        userIdTextField.delegate = self
    }
    func updateUserIdUI(_ isUserIdValid: Bool) {
        createUserButton.isEnabled = isUserIdValid
        userIdErrorsLabel.isHidden = isUserIdValid
        userIdImageView.tintColor = isUserIdValid ? UIColor.systemGreen : UIColor.systemRed
    }
    
    //MARK: - Animation methods
    //
    func completionAnimation(){
        let animationDuration = 0.5
        if let sound = SystemSoundID(exactly: 1407), let vibration = SystemSoundID(exactly: 1394) {
            AudioServicesPlaySystemSound(sound)
            AudioServicesPlaySystemSound(vibration)
        }
        UIView.animate(withDuration: animationDuration, animations: {
            self.userCreatedImageView.alpha = 1.0
        }) { (animationsFinishedBeforeCompletion) in
            self.viewModel.saveUserId()
        }
    }
    
    //MARK: - Actions
    //
    @IBAction func createUser(_ sender: Any) {
        createUserButton.isEnabled = false
        completionAnimation()
    }
    
    //MARK: - Touches
    //
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let userId = textField.text else {return}
        let validUserId = userId.replacingOccurrences(of: " ", with: "")
        viewModel.userId = validUserId
        let isUserIdValid = validUserId.count >= 8
        updateUserIdUI(isUserIdValid)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
