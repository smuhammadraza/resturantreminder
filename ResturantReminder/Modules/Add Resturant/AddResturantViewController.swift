//
//  AddResturantViewController.swift
//  ResturantReminder
//
//  Created by Mehdi Haider on 16/12/2021.
//

import UIKit
import AVFoundation
import QRCodeReader

class AddResturantViewController: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldURL: UITextField!
    @IBOutlet weak var textFieldNotes: UITextField!
    @IBOutlet weak var addRestaurantView: UIView!
    @IBOutlet weak var qrScannerViewView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    lazy var reader: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            let readerView = QRCodeReaderContainer(displayable: QRScannerView())
            
            $0.readerView = readerView
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    // MARK: - VARIABLES
    
    var viewModel = AddResturantViewModel()
    var categories = [String]()
    
    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connectFields()
        self.setupViews()
    }
    
    
    // MARK: - SETUP VIEW
    private func connectFields() {
        UITextField.connectFields(fields: [self.textFieldName, self.textFieldAddress, self.textFieldPhone, self.textFieldURL, self.textFieldNotes])
    }
    
    private func setupViews() {
        self.addRestaurantView.isHidden = self.segmentControl.selectedSegmentIndex == 1
        self.qrScannerViewView.isHidden = self.segmentControl.selectedSegmentIndex == 0
    }
    
    // MARK: - BUTTON ACTION
    
    @IBAction func didTapSaveButton(_ sender: UIButton) {
        viewModel.addResturant(userID: UserModel.shared.userID, name: self.textFieldName.text ?? "", address: self.textFieldAddress.text ?? "", phone: self.textFieldPhone.text ?? "", url: self.textFieldURL.text ?? "", notes: self.textFieldNotes.text ?? "", categories: self.categories)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmantControlTapped(_ sender: UISegmentedControl) {
        self.addRestaurantView.isHidden = sender.selectedSegmentIndex == 1
        self.qrScannerViewView.isHidden = sender.selectedSegmentIndex == 0
    }
    // MARK: - HELPER METHODS

}

extension AddResturantViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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

extension AddResturantViewController: StoryboardInitializable {}
