//
//  CategoryCollectionViewCell.swift
//  ResturantReminder
//
//  Created by Mehdi Haider on 16/12/2021.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(title: String) {
        self.titleLabel.text = title
    }
    
    @IBAction func crossAction(_ sender: UIButton) {
        
    }
}
