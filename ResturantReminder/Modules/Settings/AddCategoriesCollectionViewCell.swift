//
//  AddCategoriesCollectionViewCell.swift
//  ResturantReminder
//
//  Created by Mehdi Haider on 16/12/2021.
//

import UIKit

class AddCategoriesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - OUTLETS
    @IBOutlet weak var viewMain: UIView!
    
    // MARK: - VARIABLES
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewMain.addShadow()
    }
    
}
