//
//  Alerts.swift
//  Islamic Center App
//
//  Created by Aqeel Ahmed on 12/22/17.
//  Copyright © 2017 Mujadidia. All rights reserved.
//

import UIKit

class Alert {
    
    public static func addCategoryAlert(vc: UIViewController, completion: @escaping ((String) -> Void)) {
        let alert = UIAlertController(title: "Category Name", message: "", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Enter Category"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            completion(alert.textFields?[0].text ?? "")
        }))
        vc.present(alert, animated: true, completion: nil)
    }
    
    public static func showAlert(vc: UIViewController,
                                 title: String,
                                 message: String,
                                 actionTitle: String = "OK",
                                 handler: ((UIAlertAction) -> Void)? = nil ) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertActionOK = UIAlertAction.init(title: actionTitle, style: UIAlertAction.Style.default, handler: handler)
        alertController.addAction(alertActionOK)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    public static func showConfirmationAlert(vc: UIViewController,
                                             title: String,
                                             message: String,
                                             alertPrederredStyle: UIAlertController.Style = .actionSheet,
                                             actionTitle1: String = "Yes",
                                             actionTitle2: String = "Cancel",
                                             actionStyle1: UIAlertAction.Style = .destructive,
                                             actionStyle2: UIAlertAction.Style = .cancel,
                                             handler1: ((UIAlertAction) -> Void)? = nil,
                                             handler2: ((UIAlertAction) -> Void)? = nil ) {
        let alertController = UIAlertController.init(title: title,
                                                     message: message,
                                                     preferredStyle: UIDevice.current.userInterfaceIdiom == .phone ? alertPrederredStyle : .alert)
        let alertActionYes = UIAlertAction.init(title: actionTitle1,
                                                style: actionStyle1,
                                                handler: handler1)
        let alertActionNo = UIAlertAction.init(title: actionTitle2,
                                               style: actionStyle2,
                                               handler: handler2)
        alertController.addAction(alertActionYes)
        alertController.addAction(alertActionNo)
        vc.present(alertController, animated: true, completion: nil)
    }
    public static func showConfirmationAlert(vc: UIViewController,
                                             title: String,
                                             message: String,
                                             actionTitle1: String,
                                             actionTitle2: String,
                                             actionTitle3: String,
                                             handler1: ((UIAlertAction) -> Void)? = nil,
                                             handler2: ((UIAlertAction) -> Void)? = nil,
                                             handler3: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController.init(title: title,
                                                     message: message,
                                                     preferredStyle:
            UIDevice.current.userInterfaceIdiom == .phone ? .actionSheet : .alert)
        let alertAction1 = UIAlertAction.init(title: actionTitle1,
                                              style: UIAlertAction.Style.default,
                                              handler: handler1)
        let alertAction2 = UIAlertAction.init(title: actionTitle2,
                                              style: UIAlertAction.Style.default,
                                              handler: handler2)
        let alertAction3 = UIAlertAction.init(title: actionTitle3,
                                              style: UIAlertAction.Style.cancel,
                                              handler: handler3)
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
        alertController.addAction(alertAction3)
        vc.present(alertController, animated: true, completion: nil)
    }
    // 4 actions alert
    public static func showConfirmationAlert(viewController: UIViewController,
                                             title: String,
                                             message: String,
                                             actionTitle1: String,
                                             actionTitle2: String,
                                             actionTitle3: String,
                                             actionTitle4: String,
                                             actionStyle1: UIAlertAction.Style,
                                             actionStyle2: UIAlertAction.Style,
                                             actionStyle3: UIAlertAction.Style,
                                             actionStyle4: UIAlertAction.Style,
                                             handler1: ((UIAlertAction) -> Void)? = nil,
                                             handler2: ((UIAlertAction) -> Void)? = nil,
                                             handler3: ((UIAlertAction) -> Void)? = nil,
                                             handler4: ((UIAlertAction) -> Void)? = nil ) {
        let alertController = UIAlertController.init(title: title,
                                                     message: message,
                                                     preferredStyle: .alert)
        let alertAction1 = UIAlertAction.init(title: actionTitle1,
                                              style: actionStyle1,//UIAlertAction.Style.default,
                                              handler: handler1)
        let alertAction2 = UIAlertAction.init(title: actionTitle2,
                                              style: actionStyle2,//UIAlertAction.Style.default,
                                              handler: handler2)
        let alertAction3 = UIAlertAction.init(title: actionTitle3,
                                              style: actionStyle3,//UIAlertAction.Style.default,
                                              handler: handler3)
        let alertAction4 = UIAlertAction.init(title: actionTitle4,
                                              style: actionStyle4,//UIAlertAction.Style.cancel,
                                              handler: handler4)
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
        alertController.addAction(alertAction3)
        alertController.addAction(alertAction4)
        viewController.present(alertController, animated: true, completion: nil)
    }
    public static func showNoInternetAlert(vc: UIViewController) {
        self.showAlert(vc: vc, title: "No Internet!", message: "Sorry! No internet connection found.")
    }
    
    public static func showAlertForSettings(vc: UIViewController, title: String, message: String) {
        self.showConfirmationAlert(vc: vc, title: title, message: message, alertPrederredStyle: .alert, actionTitle1: "Settings", actionTitle2: "Cancel", actionStyle1: .default, actionStyle2: .default) { action in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                } else {
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
        } handler2: { action in
            // Do nothing
        }
    }
}
