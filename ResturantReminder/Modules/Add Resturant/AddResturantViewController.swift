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
import FBSDKCoreKit
import FBSDKShareKit
import Social

class AddResturantViewController: UIViewController {

    // MARK: - OUTLETS
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var addressAnchor: UIView!
    @IBOutlet weak var categoriesAnchor: UIView!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldURL: UITextField!
    @IBOutlet weak var textFieldNotes: UITextField!
    @IBOutlet weak var addRestaurantView: UIView!
    @IBOutlet weak var qrScannerViewView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var previousCategoriesButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
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
    var selectedRestaurantImage: UIImage?
    var scannerVC = ScannerViewController.initFromStoryboard(name: Constants.Storyboards.main)
    var selectedRestaurantRef = ""
    var titleText = "Add Restaurant"
    var restaurantModel: ResturantModel?
    var fromEdit = false
    
    //MARK: - CALLBACKS
    var navigateBackToHome: (() -> Void)?
    
    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connectFields()
        self.fetchCategories()
        self.setupViews()
        self.setupDropDowns()
        self.qrCallback()
        if let restaurantModel = restaurantModel {
            self.fromEdit = true
            self.fillFields(restaurantModel: restaurantModel)
        }
    }
    
    //MARK: - VALIDATION
    
    private func validateFields() -> Bool {
        return (!((self.textFieldName.text ?? "").isEmpty) && !((self.textFieldAddress.text ?? "").isEmpty) && (self.selectedRestaurantCoordinates != nil))
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
    
    private func fillFields(restaurantModel: ResturantModel) {
        self.textFieldName.text = restaurantModel.name
        self.textFieldAddress.text = restaurantModel.address
        self.textFieldURL.text = restaurantModel.url
        self.textFieldNotes.text = restaurantModel.notes
        self.textFieldPhone.text = restaurantModel.phone
        self.categories = restaurantModel.categories ?? []
        self.selectedRestaurantRef = restaurantModel.restaurantID ?? ""
        guard let latitude = restaurantModel.location?.latitude else { return }
        guard let longitude = restaurantModel.location?.longitude else { return }
        self.selectedRestaurantCoordinates = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
    }
    
    private func setupDropDowns() {
        self.setupAddressDropDown()
        self.setupCategoriesDropDown()
    }
    
    private func setupAddressDropDown() {
        addressDropDown.direction = .bottom
        addressDropDown.anchorView = addressAnchor
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
        categoriesDropDown.anchorView = categoriesAnchor
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
        self.titleLabel.text = self.titleText
        self.addRestaurantView.isHidden = self.segmentControl.selectedSegmentIndex == 1
        self.containerView.isHidden = self.segmentControl.selectedSegmentIndex == 0
        self.textFieldAddress.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        self.fetchPlacesAutoComplete(text: textFieldAddress.text ?? "")
    }
    
    private func fetchPlacesAutoComplete(text: String) {
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
    
    //MARK: - UPDATE VIEWS
    
    private func updateViews(accordingTo QRdata: [String]) {
        if QRdata.count >= 3 {
            self.textFieldName.text = QRdata[0]
            self.textFieldAddress.text = QRdata[1]
            self.textFieldPhone.text = QRdata[2]
            self.fetchPlacesAutoComplete(text: textFieldAddress.text ?? "")
        } else {
            self.segmentControl.selectedSegmentIndex = 0
            self.containerView.isHidden = true
            self.addRestaurantView.isHidden = false
            Snackbar.showSnackbar(message: "Unable to fetch Data from QR Code, please try again later.", duration: .middle)
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
                    self.containerView.isHidden = true
                    self.addRestaurantView.isHidden = false
                }
                return
            }
            if url.contains("restaurantreminder") {
                self.viewModel.getScannedData(url: url) { (responseString, errorString) in
                    if let errorString = errorString {
                        DispatchQueue.main.async {
                            UIApplication.stopActivityIndicator()
                            Snackbar.showSnackbar(message: errorString, duration: .middle)
                            self.segmentControl.selectedSegmentIndex = 0
                            self.containerView.isHidden = true
                            self.addRestaurantView.isHidden = false
                        }
                        return
                    }
                    
                    if let responseString = responseString {
                        DispatchQueue.main.async {
                            UIApplication.stopActivityIndicator()
                            self.segmentControl.selectedSegmentIndex = 0
                            self.containerView.isHidden = true
                            self.addRestaurantView.isHidden = false
                            let parsedData = self.parseHTML(string: self.removeHTMLTags(string: responseString))
                            self.updateViews(accordingTo: parsedData)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    UIApplication.stopActivityIndicator()
                    self.segmentControl.selectedSegmentIndex = 0
                    self.containerView.isHidden = true
                    self.addRestaurantView.isHidden = false
                    Snackbar.showSnackbar(message: "Please scan a valid QR Code.", duration: .middle)
                }
            }
            
        }
    }
    
    //MARK: - PARSE HTML
    
    private func removeHTMLTags(string: String) -> String {
        let wordsToRemove = ["<HTML>", "</HTML>", "<BODY>", "</BODY>", "\r", "\""]
        var updatedString = string
        for word in wordsToRemove {
            updatedString = updatedString.replacingOccurrences(of: word, with: "")
        }
        return updatedString
    }
    
    private func parseHTML(string: String) -> [String] {
        let delimiter = "<BR>"
        let parsedValues = string.components(separatedBy: delimiter)
        print(parsedValues)
        return Array(parsedValues.prefix(3))
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
            if self.categories.isEmpty {
                UIApplication.stopActivityIndicator()
                Snackbar.showSnackbar(message: "Categories must not be empty.", duration: .middle)
            }
            else {
                if fromEdit {
                    self.editRestaurant()
                    self.dismiss(animated: true) {
                        UIApplication.stopActivityIndicator()
                        self.navigateBackToHome?()
                    }
                } else {
                    self.addRestaurant(completion: { [weak self] in
                        UIApplication.stopActivityIndicator()
                        NotificationCenter.default.post(name: .dismissAddRestaurant, object: nil)
                        self?.dismiss(animated: true, completion: nil)
                    })
                }
            }
        } else {
            UIApplication.stopActivityIndicator()
            Snackbar.showSnackbar(message: "Please fill all fields", duration: .middle)
        }
    }
    
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        self.addRestaurantView.isHidden = sender.selectedSegmentIndex == 1
        self.containerView.isHidden = self.segmentControl.selectedSegmentIndex == 0
        if !(self.containerView.isHidden) {
            containerView.addSubview(scannerVC.view)
        }
    }
 
    
    @IBAction func categoriesDropDownTapped(_ sender: UIButton) {
        self.categoriesDropDown.show()
    }
    
    // MARK: - HELPER METHOD
    
    private func facebookShare(url: String) {
        guard let url = URL(string: url) else {
            // handle and return
            return
        }

    }
    
    private func shareInFacebook(image: UIImage) {
        let photo = SharePhoto(image: image, userGenerated: true)
        let content = SharePhotoContent()
        content.photos = [photo]
        if !(self.textFieldURL.text?.isEmpty ?? true) {
            content.contentURL = URL(string: self.textFieldURL.text ?? "www.restaurantreminder.com")!
        } else {
            content.contentURL = URL(string: "www.restaurantreminder.com")!
        }
        let showDialog = ShareDialog(fromViewController: self, content: content, delegate: self)
        
        if (showDialog.canShow) {
            showDialog.show()
        } else {
            Snackbar.showSnackbar(message: "It looks like you don't have the Facebook mobile app on your phone.", duration: .middle)
        }
    }
    
    private func addRestaurant(completion: @escaping ()->()) {
        viewModel.addResturant(userID: UserModel.shared.userID,
                               name: self.textFieldName.text ?? "",
                               address: self.textFieldAddress.text ?? "",
                               phone: self.textFieldPhone.text ?? "",
                               rating: ratingView.rating,
                               url: self.textFieldURL.text ?? "",
                               notes: self.textFieldNotes.text ?? "",
                               categories: self.categories,
                               latitude: String(selectedRestaurantCoordinates?.latitude ?? 0.0),
                               longitude: String(selectedRestaurantCoordinates?.longitude ?? 0.0),
                               selectedRestaurantImage: selectedRestaurantImage) { [weak self] (error, databaseRef) in
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
                    self.shareInFacebook(image: self.selectedRestaurantImage ?? UIImage(named: "NoImage-Placeholder")!)
//                    let resturantImage = self.selectedRestaurantImage ?? UIImage(named: "NoImage-Placeholder")!
//                    self.viewModel.uploadRestaurantImage(image: resturantImage,
//                                                         restaurantID: self.selectedRestaurantRef)
                    //                    sel!f.facebookShare(url: self.textFieldURL.text ?? "www.restaurantreminder.com")
                    completion()
                } else {
                    Snackbar.showSnackbar(message: "Something went wrong!", duration: .short)
                }
            } else {
                Snackbar.showSnackbar(message: "Something went wrong!", duration: .short)
                return
            }
        }
        
    }
    
    private func editRestaurant() {
        viewModel.editResturant(restaurantID: self.restaurantModel?.restaurantID ?? "",
                                userID: UserModel.shared.userID,
                                name: self.textFieldName.text ?? "",
                                address: self.textFieldAddress.text ?? "",
                                phone: self.textFieldPhone.text ?? "",
                                rating: ratingView.rating,
                                url: self.textFieldURL.text ?? "",
                                notes: self.textFieldNotes.text ?? "",
                                categories: self.categories,
                                latitude: String(selectedRestaurantCoordinates?.latitude ?? 0.0),
                                longitude: String(selectedRestaurantCoordinates?.longitude ?? 0.0)) { [weak self] (error, databaseRef) in
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
                    self.shareInFacebook(image: self.selectedRestaurantImage ?? UIImage(named: "NoImage-Placeholder")!)
                    self.viewModel.uploadRestaurantImage(image: self.selectedRestaurantImage ?? UIImage(named: "NoImage-Placeholder")!, restaurantID: self.selectedRestaurantRef, completion: {})
                    //                    sel!f.facebookShare(url: self.textFieldURL.text ?? "www.restaurantreminder.com")
                }
            } else {
                return
            }
        }
        
    }
    
    private func fetchSelectedPlaceDetails() {
        self.viewModel.fetchPlaceDetails(with: self.selectedPlaceID) { [weak self] (coordinates, image, error) in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let coordinates = coordinates {
                self.selectedRestaurantCoordinates = coordinates
                self.selectedRestaurantImage = image
//                self.startRegionMonitoring(with: coordinates)
            }
        }
    }

    //MARK: - REGION MONITORING
    private func startRegionMonitoring(with coordinates: CLLocationCoordinate2D) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.monitorRegionAtLocation(center: coordinates, identifier: self.selectedRestaurantRef)
//        LocationManager.shared.monitorRegionAtLocation(center: coordinates, identifier: self.selectedRestaurantRef)
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

extension AddResturantViewController: SharingDelegate {
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        print("share results: \(results)")
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print("share failed with: \(error.localizedDescription)")
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
        print("share cancel with: \(sharer.description)")
    }
}
