//
//  Snackbar.swift
//  ResturantReminder
//
//  Created by Faraz on 12/19/21.
//

import Foundation
import TTGSnackbar

class Snackbar {
    
    public static func showSnackbar(message: String, duration: TTGSnackbarDuration) {
        let snackbar = TTGSnackbar(message: message, duration: duration)
        snackbar.show()
    }
}
