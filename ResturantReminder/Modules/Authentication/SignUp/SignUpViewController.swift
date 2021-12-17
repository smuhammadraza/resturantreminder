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
    }
    
    @IBAction func didTapBackToLoginButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - HELPER METHODS
    
}


extension SignUpViewController: StoryboardInitializable {}
