//
//  MyProfileViewModel.swift
//  ResturantReminder
//
//  Created by Faraz on 12/20/21.
//

import Foundation
import FirebaseStorage

class MyProfileViewModel {
    
    func addAbout(aboutText: String) {
        FirebaseManager.shared.addUserAbout(text: aboutText)
        UserModel.shared.about = aboutText
        AppDefaults.currentUser?.about = aboutText
    }
    
    func fetchAbout(completion: @escaping (String?) -> Void) {
        FirebaseManager.shared.fetchUserAbout { error in
            completion(error)
        }
    }
    
    func updateName(name: String) {
        FirebaseManager.shared.updateName(name: name)
        UserModel.shared.fullName = name
        AppDefaults.currentUser?.fullName = name
    }
    
    func uploadProfilePicture(image: UIImage) {
        let imageRef = Storage.storage().reference().child("\(AppDefaults.currentUser?.userID ?? "")/profilePic/image.jpg")
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            let urlString = downloadURL.absoluteString
            print("image url: \(urlString)")
        }
    }
    
    func fetchProfilePicture(completion: @escaping ((UIImage?, String?)-> Void)) {
        let imageRef = Storage.storage().reference().child("\(AppDefaults.currentUser?.userID ?? "")/profilePic/image.jpg")
        StorageService.getImage(reference: imageRef, completion: completion)
    }
    
}
