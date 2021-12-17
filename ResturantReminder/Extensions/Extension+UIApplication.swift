//
//  Extension+UIApplication.swift
//  VenueVision
//
//  Created by Invision040-Raza on 17/09/2019.
//  Copyright © 2019 Muhammad Raza. All rights reserved.
//

import Foundation
//import JGProgressHUD
//import SideMenuSwift
//
//extension UIApplication {
//    class func startActivityIndicator(with message: String? = "") {
//        DispatchQueue.main.async {
//            let hud = JGProgressHUD(style: .dark)
//            hud.tag = 999
//            hud.textLabel.text = message
//            if let view = UIApplication.shared.keyWindow {
//                hud.show(in: view)
//            }
//        }
//    }
//    
//    class func stopActivityIndicator() {
//        DispatchQueue.main.async {
//            if let hud = UIApplication.shared.keyWindow?.viewWithTag(999) as? JGProgressHUD {
//                hud.dismiss()
//                hud.removeFromSuperview()
//            }
//        }
//    }
//    
//    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController {
//        if let sideMenu = controller as? SideMenuController {
//            return topViewController(controller: sideMenu.contentViewController)
//        }
//        if let navigationController = controller as? UINavigationController {
//            return topViewController(controller: navigationController.visibleViewController)
//        }
//        if let tabController = controller as? UITabBarController {
//            if let selected = tabController.selectedViewController {
//                return topViewController(controller: selected)
//            }
//        }
//        if let presented = controller?.presentedViewController {
//            return topViewController(controller: presented)
//        }
//        return controller!
//    }
//}


extension Encodable {
    
    /// Converting object to postable dictionary
    func toDictionary(_ encoder: JSONEncoder = JSONEncoder()) throws -> [String: Any] {
        let data = try encoder.encode(self)
        let object = try JSONSerialization.jsonObject(with: data)
        guard let json = object as? [String: Any] else {
            let context = DecodingError.Context(codingPath: [], debugDescription: "Deserialized object is not a dictionary")
            throw DecodingError.typeMismatch(type(of: object), context)
        }
        return json
    }
}
