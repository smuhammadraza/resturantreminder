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
    @IBOutlet weak var imageHomeTab: UIImageView!
    @IBOutlet weak var labelHomeTab: UILabel!
    @IBOutlet weak var imageProfileTab: UIImageView!
    @IBOutlet weak var labelProfileTab: UILabel!
    
    // MARK: - VARIABLES
    
    override var selectedIndex: Int {
        didSet {
            self.tabSelected(at: self.selectedIndex)
        }
    }
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabbarView()
        self.tabSelected(at: 0)
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
        presenter.dismissOnSwipe = true
        presenter.roundCorners = true
        presenter.cornerRadius = 10.0
        customPresentViewController(presenter, viewController: vc, animated: true)
    }
    
    @IBAction func didTapHomeTabButton(_ sender: UIButton) {
        self.selectedIndex = 0
        self.tabSelected(at: self.selectedIndex)
    }
    
    @IBAction func didTapMyProfileTabButton(_ sender: UIButton) {
        self.selectedIndex = 1
        self.tabSelected(at: self.selectedIndex)
    }
    
    
    private func tabSelected(at index: Int) {
        switch index {
        case 0:
            self.imageHomeTab.image = UIImage.init(named: "HomeTabSelected")
            self.labelHomeTab.textColor = UIColor.init(hex: 0x4FA971)
            
            self.imageProfileTab.image = UIImage.init(named: "HomeTabProfileUnSelected")
            self.labelProfileTab.textColor = UIColor.init(named: "DarkGreyTextColor")
        default:
            self.imageHomeTab.image = UIImage.init(named: "HomeTabUnselected")
            self.labelHomeTab.textColor = UIColor.init(named: "DarkGreyTextColor")
            
            self.imageProfileTab.image = UIImage.init(named: "HomeTabProfileSelected")
            self.labelProfileTab.textColor = UIColor.init(hex: 0x4FA971)
        }
    }
    
}

extension MainTabBarController: StoryboardInitializable {}
