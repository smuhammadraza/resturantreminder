//
//  HomeCollectionViewCell.swift
//  ResturantReminder
//
//  Created by Mehdi Haider on 15/12/2021.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

    // MARK: - OUTLETS
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    // MARK: - VARIABLES
    
    // MARK: - VIEW LIFE CYCLE
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - CONFIGURE CELL
    func configure(model: ResturantModel) {
        titleLabel.text = model.name
        if model.notes != "" {
            subTitleLabel.text = model.notes
        } else {
            subTitleLabel.text = "N/A"
        }
        ratingLabel.text = "\(String(describing: model.rating?.roundTo(places: 1) ?? 0.0))"
    }
}
