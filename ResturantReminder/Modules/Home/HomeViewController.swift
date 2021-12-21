//
//  HomeViewController.swift
//  ResturantReminder
//
//  Created by Mehdi Haider on 15/12/2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    // MARK: - VARIABLES
    var viewModel = HomeViewModel()
    var restaurant = [ResturantModel]()
    
    // MARK: - VIEW LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userNameLabel.text = "Hey, \(AppDefaults.currentUser?.fullName ?? "")"
        UIApplication.startActivityIndicator(with: "")
        viewModel.fetchResturant(userID: AppDefaults.currentUser?.userID ?? "", resturantID: "") { restaurantModel, error in
            print(error)
            print(restaurantModel)
            if let restaurantModel = restaurantModel {
                self.restaurant = restaurantModel
                if self.restaurant.isEmpty {
                    self.tableView.isHidden = true
                } else {
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            }
            UIApplication.stopActivityIndicator()
        }
        
        //        self.userProfileImageView.setimage
    }
    // MARK: - SETUP VIEW
    
    private func setupView() {
        registerTableViewCell()
    }
    
    private func registerTableViewCell() {
        self.tableView.register(UINib.init(nibName: Constants.CellIdentifiers.HomeTableViewCell,
                                           bundle: .main),
                                forCellReuseIdentifier: Constants.CellIdentifiers.HomeTableViewCell)
    }
    
    // MARK: - BUTTON ACTIONS
    
    @IBAction func profileButtonTapped(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }
    
    // MARK: - HELPER METHODS
    
}


extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.HomeTableViewCell, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(model: self.restaurant)
        return cell
    }
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Utilities.convertIphone6ToIphone5(size: 300.0)
    }
}

extension HomeViewController: StoryboardInitializable {}
