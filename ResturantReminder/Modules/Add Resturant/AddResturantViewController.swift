//
//  AddResturantViewController.swift
//  ResturantReminder
//
//  Created by Mehdi Haider on 16/12/2021.
//

import UIKit
import AVFoundation
import Cosmos
import DropDown
import CoreLocation

class AddResturantViewController: UIViewController {

    // MARK: - OUTLETS
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldURL: UITextField!
    @IBOutlet weak var textFieldNotes: UITextField!
    @IBOutlet weak var addRestaurantView: UIView!
    @IBOutlet weak var qrScannerViewView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var previousCategoriesButton: UIButton!
    
    // MARK: - VARIABLES
    
    var placeName = [String]()
    var placeID = [String]()
    var selectedPlaceID = ""
    var viewModel = AddResturantViewModel()
    var categories = [String]()
    var fetchedCategories = [String]()
    var selectionClousureAddress: SelectionClosure?
    var selectionClousureCategories: SelectionClosure?
    var addressDropDown = DropDown()
    var categoriesDropDown = DropDown()
    var selectedRestaurantCoordinates: CLLocationCoordinate2D?

    var scannerVC = ScannerViewController.initFromStoryboard(name: Constants.Storyboards.main)
    var selectedRestaurantRef = ""
    
    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connectFields()
        self.fetchCategories()
        self.setupViews()
        self.setupDropDowns()
        self.qrCallback()
    }
    
    //MARK: - VALIDATION
    
    private func validateFields() -> Bool {
        return (!((self.textFieldName.text ?? "").isEmpty) && !((self.textFieldAddress.text ?? "").isEmpty) && !((self.textFieldPhone.text ?? "").isEmpty) && (self.selectedRestaurantCoordinates != nil))
    }
    
    private func validatePhoneNumber() -> Bool {
        let phoneNumber = self.textFieldPhone.text ?? ""
        let range = NSRange(location: 0, length: phoneNumber.count)
        let regex = try! NSRegularExpression(pattern: "(\\([0-9]{3}\\) |[0-9]{3})[0-9]{3}[0-9]{4}")
        return regex.firstMatch(in: phoneNumber, options: [], range: range) != nil
    }
    
    private func validateWebsite() -> Bool {
        if let websiteString = self.textFieldURL.text {
            return websiteString.isValidURL
        } else {
            return false
        }
    }
    
    // MARK: - SETUP VIEW
    
    private func setupDropDowns() {
        self.setupAddressDropDown()
        self.setupCategoriesDropDown()
    }
    
    private func setupAddressDropDown() {
        addressDropDown.direction = .bottom
        addressDropDown.anchorView = textFieldAddress
        self.selectionClousureAddress = { [weak self] (index: Int, item: String) in
            guard let `self` = self else { return }
            self.addressDropDown.hide()
            print("Selected item: \(item) at index: \(index)")
            self.textFieldAddress.text = "\(item)"
            self.selectedPlaceID = self.placeID[index]
            self.fetchSelectedPlaceDetails()
        }
        addressDropDown.selectionAction = self.selectionClousureAddress
    }
    
    private func setupCategoriesDropDown() {
        categoriesDropDown.direction = .bottom
        categoriesDropDown.anchorView = self.previousCategoriesButton
        self.selectionClousureCategories = { [weak self] (index: Int, item: String) in
            guard let `self` = self else { return }
            self.categoriesDropDown.hide()
            print("Selected item: \(item) at index: \(index)")
            self.categories.append(item)
            self.collectionView.reloadData()
        }
        categoriesDropDown.selectionAction = self.selectionClousureCategories
    }
    
    private func connectFields() {
        UITextField.connectFields(fields: [self.textFieldName, self.textFieldAddress, self.textFieldPhone, self.textFieldURL, self.textFieldNotes])
    }
    
    private func setupViews() {
        self.addRestaurantView.isHidden = self.segmentControl.selectedSegmentIndex == 1
        self.containerView.isHidden = self.segmentControl.selectedSegmentIndex == 0
        self.textFieldAddress.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        viewModel.fetchPlacesAutoComplete(text: textFieldAddress.text ?? "") { (place, error) in
            if let error = error {
                Snackbar.showSnackbar(message: error, duration: .middle)
                return
            }
            guard let place = place else { return }
            print(place)
            self.placeID.removeAll()
            self.placeName.removeAll()
            for place in place {
                self.placeID.append(place.placeID)
                self.placeName.append(place.attributedFullText.string)
            }
            self.addressDropDown.dataSource = self.placeName
            self.addressDropDown.show()
        }
    }
    
    // MARK: - QR CALLBACK
    
    private func qrCallback() {
        scannerVC.sendQRDataBackwards = { [weak self] url in
            DispatchQueue.main.async {
                UIApplication.startActivityIndicator(with: "Please wait...")
            }
            guard let self = self else { return }
            guard let url = url else {
                DispatchQueue.main.async {
                    UIApplication.stopActivityIndicator()
                    Snackbar.showSnackbar(message: "Unable to fetch URL, please try again later.", duration: .middle)
                    self.segmentControl.selectedSegmentIndex = 0
                    self.scannerVC.view.removeFromSuperview()
                    self.addRestaurantView.isHidden = false
                }
                return
            }
            self.viewModel.getScannedData(url: url) { (responseString, errorString) in
                if let errorString = errorString {
                    DispatchQueue.main.async {
                        UIApplication.stopActivityIndicator()
                        Snackbar.showSnackbar(message: errorString, duration: .middle)
                        self.segmentControl.selectedSegmentIndex = 0
                        self.scannerVC.view.removeFromSuperview()
                    }
                    return
                }
                
                if let responseString = responseString {
                    DispatchQueue.main.async {
                        UIApplication.stopActivityIndicator()
                        self.segmentControl.selectedSegmentIndex = 0
                        self.scannerVC.view.removeFromSuperview()
                    }
                    print(responseString) // FIXME: - Parse HTML here
                }
                
            }
        }
    }
    
    //MARK: - FETCH DATA
    
    private func fetchCategories() {
        self.fetchedCategories.removeAll()
        UIApplication.startActivityIndicator(with: "")
        viewModel.fetchCategories { fetchedCategories in
            UIApplication.stopActivityIndicator()
            guard let fetchedCategories = fetchedCategories else {
                self.previousCategoriesButton.isHidden = true
                return
            }
            self.fetchedCategories = fetchedCategories
            self.previousCategoriesButton.isHidden = self.fetchedCategories.isEmpty
            self.categoriesDropDown.dataSource = self.fetchedCategories
        }
    }
    
    // MARK: - BUTTON ACTION
    
    @IBAction func didTapSaveButton(_ sender: UIButton) {
        UIApplication.startActivityIndicator(with: "")
        if validateFields() {
            if !(validatePhoneNumber()) {
                UIApplication.stopActivityIndicator()
                Snackbar.showSnackbar(message: "Phone Number is not valid", duration: .middle)
            } else if !(validateWebsite()) {
                UIApplication.stopActivityIndicator()
                Snackbar.showSnackbar(message: "Website is not valid", duration: .middle)
            } else {
                self.addRestaurant()
                UIApplication.stopActivityIndicator()
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            UIApplication.stopActivityIndicator()
            Snackbar.showSnackbar(message: "Please fill all fields", duration: .middle)
        }
    }
    
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        self.addRestaurantView.isHidden = sender.selectedSegmentIndex == 1
        self.containerView.isHidden = self.segmentControl.selectedSegmentIndex == 0
        if self.containerView.isHidden {
            scannerVC.view.removeFromSuperview()
        } else {
            containerView.addSubview(scannerVC.view)
        }
    }
 
    
    @IBAction func categoriesDropDownTapped(_ sender: UIButton) {
        self.categoriesDropDown.show()
    }
    
    // MARK: - HELPER METHOD
    
    private func addRestaurant() {
        viewModel.addResturant(userID: UserModel.shared.userID, name: self.textFieldName.text ?? "", address: self.textFieldAddress.text ?? "", phone: self.textFieldPhone.text ?? "", rating: ratingView.rating, url: self.textFieldURL.text ?? "", notes: self.textFieldNotes.text ?? "", categories: self.categories) {
            [weak self] (error, databaseRef) in
            guard let self = self else { return }
            if let error = error {
                Snackbar.showSnackbar(message: error.localizedDescription, duration: .short)
            }
            print(databaseRef)
            let dbURL = databaseRef.url

            let index = dbURL.range(of: "/", options: .backwards)?.upperBound
            if let index = index {
                let restaurantNodeString = dbURL.substring(from: index)
                print(restaurantNodeString)
                self.selectedRestaurantRef = restaurantNodeString
                if let selectedRestaurantCoordinates = self.selectedRestaurantCoordinates,
                   !(self.selectedRestaurantRef.isEmpty) {
                    self.viewModel.addCategories(categories: self.categories)
                    self.startRegionMonitoring(with: selectedRestaurantCoordinates)
                }
            } else {
                return
            }
        }
        
    }
    
    private func fetchSelectedPlaceDetails() {
        self.viewModel.fetchPlaceDetails(with: self.selectedPlaceID) { [weak self] (coordinates, error) in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let coordinates = coordinates {
                self.selectedRestaurantCoordinates = coordinates
//                self.startRegionMonitoring(with: coordinates)
            }
        }
    }

    private func startRegionMonitoring(with coordinates: CLLocationCoordinate2D) {
        LocationManager.shared.monitorRegionAtLocation(center: coordinates, identifier: self.selectedRestaurantRef)
    }
}

extension AddResturantViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
                if !(category.isEmpty) {
                    self.categories.append(category)
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width/3 - 8, height: Utilities.convertIphone6ToIphone5(size: 50))
    }
    
}

extension AddResturantViewController: StoryboardInitializable {}

//extension AddResturantViewController: UITextFieldDelegate {
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == textFieldAddress {
//            self.textFieldAddress.text = self.placeName
//        }
//    }
//}
