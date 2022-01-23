//
//  StorageService.swift
//  ResturantReminder
//
//  Created by Faraz on 1/22/22.
//

import FirebaseStorage

struct StorageService {

    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
        // 1
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return completion(nil)
        }

        // 2
        reference.putData(imageData, metadata: nil, completion: { (metadata, error) in
            // 3
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }

            // 4
            reference.downloadURL(completion: { (url, error) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return completion(nil)
                }
                completion(url)
            })
        })
    }
    
    static func getImage(reference: StorageReference, completion: @escaping ((UIImage?, String?)-> Void)) {
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        reference.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
            completion(nil, error.localizedDescription)
          } else {
            // Data for "images/island.jpg" is returned
            if let data = data {
                completion(UIImage(data: data), nil)
            } else {
                completion(nil, "Couldn't fetch image.")
            }
          }
        }
    }
    
}
