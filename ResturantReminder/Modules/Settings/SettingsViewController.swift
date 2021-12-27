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
    @IBOutlet weak var facebookSwitch: UISwitch!
    @IBOutlet weak var twitterSwitch: UISwitch!
    @IBOutlet weak var alertNearBySwitch: UISwitch!
    
    // MARK: - VARIABLES
    var selectionClousureNearbyDistance: SelectionClosure?
    lazy var dropDownNearbyDistance: DropDown = {
        let dropDown = DropDown()
        dropDown.anchorView = buttonNearByDistance
        dropDown.dataSource = ["0.5","1","2"]
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.selectionAction = self.selectionClousureNearbyDistance
        return dropDown
    }()
    
    var selectionClousureNumberOfNotifications: SelectionClosure?
    lazy var dropDownNumberOfNotifications: DropDown = {
        let dropDown = DropDown()
        dropDown.anchorView = buttonNumberOfNotifications
        dropDown.dataSource = ["1","2","3"]
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.selectionAction = self.selectionClousureNumberOfNotifications
        return dropDown
    }()
    
    var categories = [String]()
    var viewModel = SettingsViewModel()
    
    var postToFacebook: Bool?
    var postToTwitter: Bool?
    var alertWhenNearBy: Bool?
    var distance: Double?
    var numberOfNotifications: Int?
    
    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchCategories()
        self.fetchSettingsData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.addSettingsData()
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
            self.labelNearbyDistance.text = "\(item) miles"
            self.distance = Double(item) ?? 0.0
        }
        
        self.selectionClousureNumberOfNotifications = { [weak self] (index: Int, item: String) in
            guard let `self` = self else { return }
            self.dropDownNumberOfNotifications.hide()
            print("Selected item: \(item) at index: \(index)")
            self.labelNumberOfNotification.text = "\(item)/Day"
            self.numberOfNotifications = Int(item) ?? 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dropDownNumberOfNotifications.hide()
        self.dropDownNearbyDistance.hide()
    }
    
    //MARK: - FETCH DATA
    
    private func fetchCategories() {
        UIApplication.startActivityIndicator(with: "")
        viewModel.fetchCategories { fetchedCategories in
            UIApplication.stopActivityIndicator()
            guard let fetchedCategories = fetchedCategories else {
                return
            }
            self.categories = fetchedCategories
            self.collectionView.reloadData()
        }
    }
    
    private func fetchSettingsData() {
        viewModel.fetchSettingsData { data, errorMsg in
            if let errorMsg = errorMsg {
                Snackbar.showSnackbar(message: errorMsg, duration: .middle)
            }
            if let data = data {
                self.postToFacebook = data.postToFacebook
                self.postToTwitter = data.postToTwitter
                self.alertWhenNearBy = data.alertWhenNearBy
                self.numberOfNotifications = data.numberOfNotifications
                self.distance = data.distance
                self.facebookSwitch.isOn = data.postToFacebook ?? false
                self.twitterSwitch.isOn = data.postToTwitter ?? false
                self.alertNearBySwitch.isOn = data.alertWhenNearBy ?? false
                self.labelNearbyDistance.text = "\((data.distance ?? 0.0).roundTo(places: 1)) miles"
                self.labelNumberOfNotification.text = "\(data.numberOfNotifications ?? 0)/Day"
            }
        }
    }
    
    // MARK: - ADD DATA
    private func addSettingsData() {
        viewModel.addSettingsData(postToFacebook: postToFacebook, postToTwitter: postToTwitter, alertWhenNearBy: alertWhenNearBy, distance: distance, numberOfNotifications: numberOfNotifications) { error, ref in
            if let error = error {
                Snackbar.showSnackbar(message: error.localizedDescription, duration: .middle)
            }
            print(ref)
        }
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
        self.postToFacebook = sender.isOn
    }
    
    @IBAction func didChangeValueAutoTweetToTwitter(_ sender: UISwitch) {
        self.postToTwitter = sender.isOn
    }
    
    @IBAction func didChangeValueAlertWhenNearby(_ sender: UISwitch) {
        self.alertWhenNearBy = sender.isOn
    }
    
    // MARK: - HELPER METHODS

}

extension SettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count + 1
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
            cell.configure(title: self.categories[indexPath.row - 1])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            Alert.addCategoryAlert(vc: self) { category in
                self.categories.append(category)
                UIApplication.startActivityIndicator(with: "")
                self.viewModel.addCategories(categories: self.categories)
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width/3 - 8, height: Utilities.convertIphone6ToIphone5(size: 50))
    }
    
}

extension SettingsViewController: StoryboardInitializable {}
