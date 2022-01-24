//
//  HomeViewController.swift
//  ResturantReminder
//
//  Created by Mehdi Haider on 15/12/2021.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var noRestaurantLabel: UILabel!
    
    // MARK: - VARIABLES
    var viewModel = HomeViewModel()
    var restaurant = [ResturantModel]()
    var categories = [String]()
    let locationManagerSingleton = LocationManager.shared
    let locationManager = LocationManager.shared.locationManager
    var notificationTimer: Int = -1 {
        didSet {
            NotificationManager.shared.triggerRandomNotification(identifier: "123", timeInterval: notificationTimer)
        }
    }
    var restaurantImages = [String: UIImage]()
    
    // MARK: - VIEW LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupObserver()
        locationManager.delegate = self
        LocationManager.shared.locationManager.delegate = self
        locationManagerSingleton.startUpdatingLocation()
//        setupLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userNameLabel.text = "Hey, \(AppDefaults.currentUser?.fullName ?? "")"
        self.fetchHomeData()
        
        self.fetchNotificationTimer()
    }
    // MARK: - SETUP VIEW
    
    private func setupView() {
        registerTableViewCell()
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: .dismissAddRestaurant, object: nil)
    }
    
    
    @objc func fetchData() {
        self.userNameLabel.text = "Hey, \(AppDefaults.currentUser?.fullName ?? "")"
        self.fetchHomeData()
    }
    
    private func registerTableViewCell() {
        self.tableView.register(UINib.init(nibName: Constants.CellIdentifiers.HomeTableViewCell,
                                           bundle: .main),
                                forCellReuseIdentifier: Constants.CellIdentifiers.HomeTableViewCell)
    }
    
    // MARK: - FETCH DATA
    
    private func fetchHomeData() {
        UIApplication.startActivityIndicator(with: "")
        viewModel.fetchResturant(userID: AppDefaults.currentUser?.userID ?? "") { restaurantModel, error in
            print(error)
            print(restaurantModel)
            if let restaurantModel = restaurantModel {
                self.restaurant = restaurantModel
                var categories = [String]()
                self.restaurant.forEach { object in
                    categories.append(contentsOf: object.categories ?? [])
                }
                self.categories = Array(Set(categories))
                if self.restaurant.isEmpty {
                    self.tableView.isHidden = true
                    self.noRestaurantLabel.isHidden = true
                    UIApplication.stopActivityIndicator()
                } else {
                    self.noRestaurantLabel.isHidden = true
                    self.tableView.isHidden = false
                    self.fetchRestaurantImages()
                }
            } else {
                self.tableView.isHidden = true
                self.noRestaurantLabel.isHidden = true
                UIApplication.stopActivityIndicator()
            }
        }
    }
    
    private func fetchRestaurantImages() {
        
        let group = DispatchGroup()
        
        for restaurant in self.restaurant {
            group.enter()
            if let restaurantID = restaurant.restaurantID {
                self.viewModel.fetchRestaurantImage(restaurantID: restaurantID) { (image, _) in
                    if let image = image {
                        self.restaurantImages[restaurantID] = image
                    }
                    group.leave()
                }
            }
        }
        let work = DispatchWorkItem.init { [weak self] in
            UIApplication.stopActivityIndicator()
            self?.tableView.reloadData()
        }
        group.notify(queue: .main, work: work)
    }
    
    private func fetchNotificationTimer() {
        FirebaseManager.shared.fetchNotificationTimer { (value) in
            guard let value = value else { return }
            self.notificationTimer = value
        }
    }
    
    // MARK: - BUTTON ACTIONS
    
    @IBAction func profileButtonTapped(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }
    
    // MARK: - HELPER METHODS
    
//    private func startUpdatingLocation() {
//        locationManager.startUpdatingLocation()
//        locationManager.startMonitoringVisits()
//        locationManager.startMonitoringSignificantLocationChanges()
//    }
}


extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.HomeTableViewCell, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.row == 0 {
            cell.configureCell(model: self.restaurant, categoryTitle: "All Restaurants", categorySubTitle: "", restaurantImages: self.restaurantImages)
        } else if indexPath.row == 1 && !(self.categories.isEmpty){
            var restaurantModel = [ResturantModel]()
            var restaurantImage = [String: UIImage]()

            self.restaurant.forEach { object in
                if object.categories?.contains(self.categories[indexPath.row]) ?? false {
                    restaurantModel.append(object)
                    self.restaurantImages.forEach { (key, value) in
                        if object.restaurantID == key {
                            restaurantImage[key] = value
                        }
                    }
//                    if object.restaurantID ==
                    cell.configureCell(model: restaurantModel, categoryTitle: "All Categories", categorySubTitle: self.categories[indexPath.row], restaurantImages: restaurantImage)
                }
            }
        } else if !(self.categories.isEmpty) && indexPath.row < self.categories.count {
            var restaurantModel = [ResturantModel]()
            var restaurantImage = [String: UIImage]()

            self.restaurant.forEach { object in
                if object.categories?.contains(self.categories[indexPath.row]) ?? false {
                    restaurantModel.append(object)
                    self.restaurantImages.forEach { (key, value) in
                        if object.restaurantID == key {
                            restaurantImage[key] = value
                        }
                    }
                    cell.configureCell(model: restaurantModel, categoryTitle: "", categorySubTitle: self.categories[indexPath.row], restaurantImages: restaurantImage)
                }
            }
        }
        cell.restaurantDetailTapped = { [weak self] model, image in
            guard let self = self else { return }
            let vc = RestaurantDetailViewController.initFromStoryboard(name: Constants.Storyboards.main)
            vc.restaurantModel = model
            vc.titleImage = image
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Utilities.convertIphone6ToIphone5(size: 300.0)
    }
}

extension HomeViewController: StoryboardInitializable {}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        FirebaseManager.shared.updateUserLocation(latitude: "\(locValue.latitude)", longitude: "\(locValue.longitude)")
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}
