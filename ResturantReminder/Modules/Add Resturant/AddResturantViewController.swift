//
//  AddResturantViewController.swift
//  ResturantReminder
//
//  Created by Mehdi Haider on 16/12/2021.
//

import UIKit
import AVFoundation
import QRCodeReader
import Cosmos

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
    lazy var reader: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            let readerView = QRCodeReaderContainer(displayable: QRScannerView())
            
            $0.readerView = readerView
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    // MARK: - VARIABLES
    var placeName = ""
    var viewModel = AddResturantViewModel()
    var categories = [String]()
    
    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connectFields()
        self.setupViews()
    }
    
    //MARK: - VALIDATION
    
    func validateFields() -> Bool {
        return (!((self.textFieldName.text ?? "").isEmpty) && !((self.textFieldAddress.text ?? "").isEmpty) && !((self.textFieldPhone.text ?? "").isEmpty))
    }
    
    // MARK: - SETUP VIEW
    private func connectFields() {
        UITextField.connectFields(fields: [self.textFieldName, self.textFieldAddress, self.textFieldPhone, self.textFieldURL, self.textFieldNotes])
    }
    
    private func setupViews() {
        self.addRestaurantView.isHidden = self.segmentControl.selectedSegmentIndex == 1
        self.qrScannerViewView.isHidden = self.segmentControl.selectedSegmentIndex == 0
        self.textFieldAddress.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        viewModel.fetchPlacesAutoComplete(text: textFieldAddress.text ?? "") { (placeName) in
            guard let placeName = placeName else { return }
            print(placeName)
            self.placeName = placeName
        }
    }
    
    // MARK: - BUTTON ACTION
    
    @IBAction func didTapSaveButton(_ sender: UIButton) {
        UIApplication.startActivityIndicator(with: "")
        if validateFields() {
            viewModel.addResturant(userID: UserModel.shared.userID, name: self.textFieldName.text ?? "", address: self.textFieldAddress.text ?? "", phone: self.textFieldPhone.text ?? "", rating: ratingView.rating, url: self.textFieldURL.text ?? "", notes: self.textFieldNotes.text ?? "", categories: self.categories)
            self.viewModel.addMeta(categories: self.categories)
            UIApplication.stopActivityIndicator()
            self.dismiss(animated: true, completion: nil)
        } else {
            UIApplication.stopActivityIndicator()
            Snackbar.showSnackbar(message: "Please fill all fields", duration: .middle)
        }
    }
    
    @IBAction func segmantControlTapped(_ sender: UISegmentedControl) {
        self.addRestaurantView.isHidden = sender.selectedSegmentIndex == 1
        self.qrScannerViewView.isHidden = sender.selectedSegmentIndex == 0
    }
    // MARK: - HELPER METHODS

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
                self.categories.append(category)
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width/3 - 8, height: Utilities.convertIphone6ToIphone5(size: 50))
    }
    
}

extension AddResturantViewController: StoryboardInitializable {}

extension AddResturantViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textFieldAddress {
            self.textFieldAddress.text = self.placeName
        }
    }
}
