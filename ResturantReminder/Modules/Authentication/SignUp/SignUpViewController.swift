//
//  SignUpViewController.swift
//  ResturantReminder
//
//  Created by Mehdi Haider on 07/12/2021.
//

import UIKit

class SignUpViewController: UIViewController {

    // MARK: - OUTLETS
    
    // MARK: - VARIABLES
    
    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - SETUP VIEW
    
    
    // MARK: - BUTTON ACTIONS
    @IBAction func didTapSignUpButton(_ sender: UIButton) {
    }
    
    @IBAction func didTapBackToLoginButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - HELPER METHODS
    
}


extension SignUpViewController: StoryboardInitializable {}
