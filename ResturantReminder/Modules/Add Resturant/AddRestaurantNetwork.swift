//
//  AddRestaurantNetwork.swift
//  ResturantReminder
//
//  Created by Faraz on 1/9/22.
//

import Foundation

class AddRestaurantNetwork {
    
    func getScannedData(url: String, completion: @escaping ((String?, String?) -> Void)) {
        guard let url = URL(string: url) else {
            completion(nil, "Unable to fetch URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            guard let data = data else {
                completion(nil, "Error fetching data, please try again later.")
                return
            }
            guard let stringResponse = String(data: data, encoding: .utf8) else {
                completion(nil, "Error fetching data, please try again later.")
                return
            }
            completion(stringResponse, nil)
        }
        task.resume()
    }
}
