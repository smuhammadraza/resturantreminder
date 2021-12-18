//
//  SettingsViewController.swift
//  ResturantReminder
//
//  Created by Mehdi Haider on 16/12/2021.
//

import UIKit
import DropDown

class SettingsViewController: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelNearbyDistance: UILabel!
    @IBOutlet weak var buttonNearByDistance: UIButton!
    @IBOutlet weak var labelNumberOfNotification: UILabel!
    @IBOutlet weak var buttonNumberOfNotifications: UIButton!
    
    // MARK: - VARIABLES
    var selectionClousureNearbyDistance: SelectionClosure?
    lazy var dropDownNearbyDistance: DropDown = {
        let dropDown = DropDown()
        dropDown.anchorView = buttonNearByDistance
        dropDown.dataSource = ["1/2 mile","1 mile","2 mile"]
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.selectionAction = self.selectionClousureNearbyDistance
        return dropDown
    }()
    
    var selectionClousureNumberOfNotifications: SelectionClosure?
    lazy var dropDownNumberOfNotifications: DropDown = {
        let dropDown = DropDown()
        dropDown.anchorView = buttonNumberOfNotifications
        dropDown.dataSource = ["1/Day","2/Day","3/Day"]
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.selectionAction = self.selectionClousureNumberOfNotifications
        return dropDown
    }()
    
    
    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    // MARK: - SETUP VIEW
    
    private func setupView() {
        setupDropDown()
    }
    
    private func setupDropDown() {
        self.selectionClousureNearbyDistance = { [weak self] (index: Int, item: String) in
            guard let `self` = self else { return }
            self.dropDownNearbyDistance.hide()
            print("Selected item: \(item) at index: \(index)")
            self.labelNearbyDistance.text = item
        }
        
        self.selectionClousureNumberOfNotifications = { [weak self] (index: Int, item: String) in
            guard let `self` = self else { return }
            self.dropDownNumberOfNotifications.hide()
            print("Selected item: \(item) at index: \(index)")
            self.labelNumberOfNotification.text = item
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dropDownNumberOfNotifications.hide()
        self.dropDownNearbyDistance.hide()
    }
    
    // MARK: - BUTTON ACTIONS
    
    // Buttons
    @IBAction func didTapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapNumberOfNotificationsButton(_ sender: UIButton) {
        self.dropDownNumberOfNotifications.show()
    }
    
    @IBAction func didTapNearbyDistanceButton(_ sender: UIButton) {
        self.dropDownNearbyDistance.show()
    }
    
    // Switches
    @IBAction func didChangeValueAutoPostToFacebook(_ sender: UISwitch) {
        
    }
    
    @IBAction func didChangeValueAutoTweetToTwitter(_ sender: UISwitch) {
        
    }
    
    @IBAction func didChangeValueAlertWhenNearby(_ sender: UISwitch) {
        
    }
    
    // MARK: - HELPER METHODS

}

extension SettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.AddCategoriesCollectionViewCell, for: indexPath) as? AddCategoriesCollectionViewCell else {
                fatalError("Unable to find collection view cell")
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.CategoryCollectionViewCell, for: indexPath) as? CategoryCollectionViewCell else {
                fatalError("Unable to find collection view cell")
            }
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width/3 - 8, height: Utilities.convertIphone6ToIphone5(size: 50))
    }
    
}

extension SettingsViewController: StoryboardInitializable {}
