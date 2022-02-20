//
//  SignUpViewController.swift
//  ResturantReminder
//
//  Created by Mehdi Haider on 07/12/2021.
//

import UIKit

class SignUpViewController: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var textFieldFullName: UITextField!
    @IBOutlet weak var textFieldPostalCode: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    
    // MARK: - VARIABLES
    var viewModel = SignUpViewModel()
    
    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connectFields()
    }
    
    // MARK: - SETUP VIEW
    private func connectFields() {
        UITextField.connectFields(fields: [self.textFieldFullName, self.textFieldPostalCode, self.textFieldEmail, self.textFieldPassword, self.textFieldConfirmPassword])
    }
    
    // MARK: - BUTTON ACTIONS
    @IBAction func didTapSignUpButton(_ sender: UIButton) {
        UIApplication.startActivityIndicator(with: "Creating Account..")
        viewModel.signUpUser(fullName: self.textFieldFullName.text ?? "", postalCode: self.textFieldPostalCode.text ?? "", email: self.textFieldEmail.text ?? "", password: self.textFieldPassword.text ?? "") { [weak self] (authResult, error) in
            guard let self = self else { return }
            if let error = error {
                UIApplication.stopActivityIndicator()
                Snackbar.showSnackbar(message: error.localizedDescription, duration: .middle)
                return
            } else {
                
                self.viewModel.addUser(userID: authResult?.user.uid ?? "", fullName: self.textFieldFullName.text ?? "", postalCode: self.textFieldPostalCode.text ?? "", email: self.textFieldEmail.text ?? "")
                
                self.viewModel.addSettingsData(userID: authResult?.user.uid ?? "", postToFacebook: false, postToTwitter: false, alertWhenNearBy: true, distance: 1.0, numberOfNotifications: 2) { _, ref in
                    print(ref)
                }

                UIApplication.stopActivityIndicator()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func didTapBackToLoginButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - HELPER METHODS
    
}


extension SignUpViewController: StoryboardInitializable {}
