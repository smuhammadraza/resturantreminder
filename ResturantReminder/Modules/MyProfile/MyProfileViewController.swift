//
//  MyProfileViewController.swift
//  ResturantReminder
//
//  Created by Mehdi Haider on 15/12/2021.
//

import UIKit
import IQKeyboardManagerSwift

class MyProfileViewController: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var aboutYourselfTextView: UITextView!
    
    // MARK: - VARIABLES
    
    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTextView()
    }
    
    // MARK: - SETUP VIEW
    
    private func setupTextView() {
        aboutYourselfTextView.delegate = self
    }
    
    // MARK: - BUTTON ACTIONS
    
    @IBAction func didTapSettingsButton(_ sender: UIButton) {
        let vc = SettingsViewController.initFromStoryboard(name: Constants.Storyboards.main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - HELPER METHODS

}

extension MyProfileViewController: StoryboardInitializable {}

extension MyProfileViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == aboutYourselfTextView {
            if textView.text == "Tell us about yourself (optional)" {
                textView.text = ""
            }
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == aboutYourselfTextView {
            if textView.text == "" {
                textView.text = "Tell us about yourself (optional)"
            }
        }
    }
}
