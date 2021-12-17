//
//  SettingsViewController.swift
//  ResturantReminder
//
//  Created by Mehdi Haider on 16/12/2021.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - VARIABLES
    
    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - SETUP VIEW
    
    
    // MARK: - BUTTON ACTIONS
    @IBAction func didTapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
