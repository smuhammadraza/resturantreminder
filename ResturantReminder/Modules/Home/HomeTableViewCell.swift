//
//  HomeTableViewCell.swift
//  ResturantReminder
//
//  Created by Mehdi Haider on 15/12/2021.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    // MARK: - OUTLETS
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - VARIABLES
    var restaurantModel = [ResturantModel]()
    
    // MARK: - VIEW LIFE CYCLE
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    // MARK: - SETUP VIEW
    
    private func setupView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        registerCollectionViewCell()
    }
    
    private func registerCollectionViewCell() {
        self.collectionView.register(UINib.init(nibName: Constants.CellIdentifiers.HomeCollectionViewCell,
                                                bundle: .main),
                                     forCellWithReuseIdentifier: Constants.CellIdentifiers.HomeCollectionViewCell)
    }
    
    // MARK: - CONFIGURE CELL
    
    func configureCell(model: [ResturantModel]) {
        self.restaurantModel = model
        self.collectionView.reloadData()
//        switch indexRow {
//        case 0:
//            self.labelTitle.text = "All Resturants"
//            self.labelSubtitle.text = ""
//            self.labelTitle.isHidden = false
//            self.labelSubtitle.isHidden = true
//        case 1:
//            self.labelTitle.text = "Categories"
//            self.labelSubtitle.text = "Breakfast"
//            self.labelTitle.isHidden = false
//            self.labelSubtitle.isHidden = false
//        default:
//            self.labelTitle.text = ""
//            self.labelSubtitle.text = "Burgers"
//            self.labelTitle.isHidden = true
//            self.labelSubtitle.isHidden = false
//        }
    }
    
    
}

extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width - 30, height: collectionView.frame.height)
    }
}

extension HomeTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.restaurantModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.HomeCollectionViewCell,
                                                            for: indexPath) as? HomeCollectionViewCell else {
            fatalError("Cannot find collection view cell")
        }
        cell.configure(model: self.restaurantModel[indexPath.row])
        return cell
    }
    
    
}
