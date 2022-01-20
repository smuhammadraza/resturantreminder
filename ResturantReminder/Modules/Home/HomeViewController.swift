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
//    private func setupLocationManager() {
//        // Ask for Authorisation from the User.
//        self.locationManager.requestAlwaysAuthorization()
//
//        // For use in foreground
//        self.locationManager.requestWhenInUseAuthorization()
//
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
//            startUpdatingLocation()
//        }
//    }
    
    private func registerTableViewCell() {
        self.tableView.register(UINib.init(nibName: Constants.CellIdentifiers.HomeTableViewCell,
                                           bundle: .main),
                                forCellReuseIdentifier: Constants.CellIdentifiers.HomeTableViewCell)
    }
    
    // MARK: - FETCH DATA
    
    private func fetchHomeData() {
        UIApplication.startActivityIndicator(with: "")
        viewModel.fetchResturant(userID: AppDefaults.currentUser?.userID ?? "", resturantID: "") { restaurantModel, error in
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
                } else {
                    self.noRestaurantLabel.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            } else {
                self.tableView.isHidden = true
                self.noRestaurantLabel.isHidden = true
            }
            UIApplication.stopActivityIndicator()
        }
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
            cell.configureCell(model: self.restaurant, categoryTitle: "All Restaurants", categorySubTitle: "")
        } else if indexPath.row == 1 && !(self.categories.isEmpty){
            var restaurantModel = [ResturantModel]()
            self.restaurant.forEach { object in
                if object.categories?.contains(self.categories[indexPath.row]) ?? false {
                    restaurantModel.append(object)
                    cell.configureCell(model: restaurantModel, categoryTitle: "All Categories", categorySubTitle: self.categories[indexPath.row])
                }
            }
        } else if !(self.categories.isEmpty) && indexPath.row < self.categories.count {
            var restaurantModel = [ResturantModel]()
            self.restaurant.forEach { object in
                if object.categories?.contains(self.categories[indexPath.row]) ?? false {
                    restaurantModel.append(object)
                    cell.configureCell(model: restaurantModel, categoryTitle: "", categorySubTitle: self.categories[indexPath.row])
                }
            }
        }
        cell.restaurantDetailTapped = { [weak self] model in
            guard let self = self else { return }
            let vc = RestaurantDetailViewController.initFromStoryboard(name: Constants.Storyboards.main)
            vc.restaurantModel = model
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
