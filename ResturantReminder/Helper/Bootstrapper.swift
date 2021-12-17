//
//  Bootstrapper.swift
//  Carzaty
//
//  Created by Raza Naqvi on 26/11/2018.
//  Copyright © 2018 Hassan. All rights reserved.
//

import Foundation
import UIKit
//import SideMenuSwift

struct Bootstrapper {
    var window: UIWindow
    
    static var instance: Bootstrapper? = nil
    static func initialize() {
        instance = Bootstrapper(window: makeNewWindow())
        instance!.bootstrap()
        Thread.sleep(forTimeInterval: 1)
    }
    static func reset() {
        let win = instance!.window
        instance!.window = makeNewWindow()
        instance!.bootstrap()
        win.rootViewController = nil
        win.removeFromSuperview()
    }
    
    
    static func showLogin() {
        instance!.showLogin()
    }
    static func showHome() {
        instance!.showHome()
    }
    
    
    private static func makeNewWindow() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        if let del = UIApplication.shared.delegate as? AppDelegate {
            del.window = window
        }
        return window
    }
    
    
    mutating func bootstrap() {
//        if AppDefaults.isUserLoggedIn && AppDefaults.currentUser != nil {
//            UserModel.shared = AppDefaults.currentUser ?? UserModel()
//            self.showHome()
//        } else {
            self.showLogin()
//        }
        window.makeKeyAndVisible()
    }
    private init(window: UIWindow) {
        self.window = window
    }
    private func showLogin() {
        let controller = LoginViewController.initFromStoryboard(name: Constants.Storyboards.authentication)
        self.window.rootViewController = controller
    }
    
    private func showHome() {
        let controller = MainTabBarController.initFromStoryboard(name: Constants.Storyboards.main)
//        let sideMenuVC = SideMenuViewController.initFromStoryboard(name: Constants.Storyboards.Main)
//        let sideMenuController = SideMenuController(contentViewController: controller, menuViewController: sideMenuVC)
        self.window.rootViewController = controller
    }
    
    
//    private func showAccountManagerHome() {
//        let controller = AccountManagerTabBarController.initFromStoryboard(name: AppRouter.Storyboards.AccountManager)
//        self.window.rootViewController = controller
//    }
//    private func showAuctionTab() {
//        let controller = AuctionTabBarViewController.initFromStoryboard(name: AppRouter.Storyboards.Auction)
//        self.window.rootViewController = controller
//    }
//    private func showHomeForSettings() {
//        if AppDefaults.isDealerLogin {
//            let viewController = MainTabBarController.initFromStoryboard(name: AppRouter.Storyboards.Main)
//            viewController.selectedIndex = 3
//            self.window.rootViewController = viewController
//        } else if AppDefaults.isAccountManagerLogin {
//            let controller = AccountManagerTabBarController.initFromStoryboard(name: AppRouter.Storyboards.AccountManager)
//            controller.selectedIndex = 1
//            self.window.rootViewController = controller
//        }
//    }
//
//    private func setupTheLanguage() {
//        //Check if user set any language
//        if VSLanguage.hasUserSelectedAnyLanguage() {
//            //User has selected a language from side menu
//            if VSLanguage.currentAppleLanguage() == "en" {
//                UIView.appearance().semanticContentAttribute = .forceLeftToRight
//            } else {
//                //UIView.appearance().semanticContentAttribute = .forceRightToLeft
//            }
//        } else {
//            //User has never set any language
//            if let languageCode = Locale.current.languageCode {
//                print("Current Device Language \(languageCode)")
//                VSLanguage.setAppleLAnguageTo(lang: "en")
//                UIView.appearance().semanticContentAttribute = .forceLeftToRight
////                if languageCode == "ar" {
////                    VSLanguage.setAppleLAnguageTo(lang: "ar")
////                    UIView.appearance().semanticContentAttribute = .forceRightToLeft
////                }else {
////                    VSLanguage.setAppleLAnguageTo(lang: "en")
////                    UIView.appearance().semanticContentAttribute = .forceLeftToRight
////                }
//            }
//        }
//    }
}
