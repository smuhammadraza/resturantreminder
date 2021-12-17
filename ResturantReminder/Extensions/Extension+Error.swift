//
//  Extension+Error.swift
//  VenueVision
//
//  Created by Invision040-Raza on 30/09/2019.
//  Copyright © 2019 Muhammad Raza. All rights reserved.
//

import Foundation
//import Moya
//
//// MARK: - ErrorModel
//struct ErrorModel: Codable {
//    let statusCode: Int?
//    let message: [String]?
//    let error: String?
//}
//
//extension Swift.Error {
//    var customDescription: String {
//        get {
//            if let error = self as? MoyaError,
//                let response = try? error.response?.map(ErrorModel.self) {
//                return response.message?.first ?? (response.error ?? error.localizedDescription)
//            }
//            var err = self.localizedDescription
//            err = err.replacingOccurrences(of: "URLSessionTask failed with error:", with: "")
//            return err  //"Something went wrong"
//        }
//    }
//    
//    var decodingErrorMessage: String {
//        get {
//            if let error = self as? DecodingError {
//                return error.failureReason ?? "Decoding Failed"
//            }
//            return "Something went wrong"
//        }
//    }
//    
//}
