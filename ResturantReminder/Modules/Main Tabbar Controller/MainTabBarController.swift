//
//  MainTabBarController.swift
//  ResturantReminder
//
//  Created by Mehdi Haider on 08/12/2021.
//

import UIKit
import Presentr

class MainTabBarController: UITabBarController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var viewCustomTabBar: UIView!
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabbarView()
    }
    
    // MARK: - SETUP VIEW
    private func setupCustomTabbarView() {
        tabBar.addSubview(viewCustomTabBar)
        viewCustomTabBar.translatesAutoresizingMaskIntoConstraints = false
        viewCustomTabBar.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor).isActive = true
        viewCustomTabBar.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor).isActive = true
        viewCustomTabBar.widthAnchor.constraint(equalTo: tabBar.widthAnchor).isActive = true
        if let customTabbar = tabBar as? MainTabBar {
            customTabbar.viewCustomTabBar = viewCustomTabBar
        }
    }
    
    // MARK: - BUTTON ACTIONS
    
    @IBAction func didTapCenterButton(_ sender: UIButton) {
        let vc = AddResturantViewController.initFromStoryboard(name: Constants.Storyboards.main)
        let presenter = Presentr.init(presentationType: .custom(width: .fluid(percentage: 1.0),
                                                                height: .fluid(percentage: 0.9), center: .center))
        presenter.roundCorners = true
        presenter.cornerRadius = 10.0
        customPresentViewController(presenter, viewController: vc, animated: true)
    }
    
    @IBAction func didTapHomeTabButton(_ sender: UIButton) {
        self.selectedIndex = 0
    }
    
    @IBAction func didTapMyProfileTabButton(_ sender: UIButton) {
        self.selectedIndex = 1
    }
    
}

extension MainTabBarController: StoryboardInitializable {}
