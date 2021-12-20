//
//  MyProfileViewController.swift
//  ResturantReminder
//
//  Created by Mehdi Haider on 15/12/2021.
//

import UIKit
import AVKit
import Photos

class MyProfileViewController: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var aboutYourselfTextView: UITextView!
    @IBOutlet weak var imageProfilePicture: UIImageView!
    
    // MARK: - VARIABLES
    private lazy var imagePicker = UIImagePickerController()
    var viewModel = MyProfileViewModel()
    
    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTextView()
        self.setupTextField()
//        self.setupValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupValues()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageProfilePicture.cornerRadius = imageProfilePicture.height/2
    }
    
    // MARK: - SETUP VIEW
    
    private func setupTextField() {
        textFieldFirstName.delegate = self
    }
    
    private func setupValues() {
        self.textFieldFirstName.text = UserModel.shared.fullName
        
        viewModel.fetchAbout { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                Snackbar.showSnackbar(message: error, duration: .middle)
            } else {
                self.aboutYourselfTextView.text = UserModel.shared.about ?? "Tell us about yourself (optional)"
            }
        }
    }
    
    private func setupTextView() {
        aboutYourselfTextView.delegate = self
    }
    
    // MARK: - BUTTON ACTIONS
    
    @IBAction func didTapProfileButton(_ sender: UIButton) {
        self.showAlertWithMediaOptions()
    }
    
    @IBAction func didTapSettingsButton(_ sender: UIButton) {
        let vc = SettingsViewController.initFromStoryboard(name: Constants.Storyboards.main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - HELPER METHODS

}

// MARK: - EXTENSION FOR CAMERA AND GALLERY OPENING
extension MyProfileViewController {
    private func showAlertWithMediaOptions() {
        Alert.showConfirmationAlert(vc: self, title: "Choose Image", message: "",
                                    actionTitle1: "Camera", actionTitle2: "Gallery", actionTitle3: "Cancel") { _ in
            self.checkIfUserHasGivenCameraPermissions()
        } handler2: { _ in
            self.checkIfUserHasGivenGalleryPermission()
        } handler3: { _ in
            // Do Nothing
        }
    }
    
    private func checkIfUserHasGivenCameraPermissions() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch (authStatus){
        case .notDetermined:
            self.requestAccessForCamera()
        case .restricted, .denied:
            showAlert(title: "Unable to access the Camera", message: "This will restart this app.\nTo enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.")
        case .authorized:
            self.openCamera()
        @unknown default:
            showAlert(title: "Unable to access the Camera", message: "Something went wrong!")
        }
    }
    
    private func checkIfUserHasGivenGalleryPermission() {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
        case .notDetermined:
            requestAccessForPhotoLibrary()
        case .restricted, .denied:
            showAlert(title: "Unable to access the Gallery", message: "This will restart this app.\nTo enable access, go to Settings > Privacy > turn on Photo Library access for this app.")
        case .authorized:
            self.openGallery()
        default:
            showAlert(title: "Unable to access the Gallery", message: "Something went wrong!")
        }
    }
    
    private func showAlert(title: String, message: String) {
        Alert.showAlert(vc: self, title: title, message: message)
//        Alert.showAlertForSettings(vc: self, title: title, message: message)
    }
    
    private func requestAccessForCamera() {
        //Camera
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response { self.openCamera() }
            else {}
        }
        
    }
    
    private func requestAccessForPhotoLibrary() {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{ self.openGallery() }
                else {}
            })
        }
    }
    
    private func openCamera() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.cameraDevice = .rear
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func openGallery() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                self.imagePicker =  UIImagePickerController()
                self.imagePicker.delegate = self
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - EXTENSION FOR IMAGE PICKER DELEGATE

extension MyProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.imageProfilePicture.image = pickedImage
            }
        }
    }
}

// MARK: - EXTENSION FOR UITEXT VIEW DELEGATE
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
            } else {
                viewModel.addAbout(aboutText: aboutYourselfTextView.text ?? "")
                UserModel.shared.about = aboutYourselfTextView.text ?? ""
            }
        }
    }
}

extension MyProfileViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.textFieldFirstName {
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.textFieldFirstName && textField.text != "" {
            viewModel.updateName(name: textFieldFirstName.text ?? "")
            UserModel.shared.fullName = textFieldFirstName.text ?? ""
        }
    }
}

// MARK: - EXTENION FOR STORYBOARD INITIALIZABLE
extension MyProfileViewController: StoryboardInitializable {}
