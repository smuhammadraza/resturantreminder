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
    
    func configureCell(model: [ResturantModel], categoryTitle: String, categorySubTitle: String) {
        self.restaurantModel = model
        self.labelTitle.isHidden = categoryTitle.isEmpty
        self.labelTitle.text = categoryTitle
        self.labelSubtitle.isHidden = categorySubTitle.isEmpty
        self.labelSubtitle.text = categorySubTitle
        self.collectionView.reloadData()
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
