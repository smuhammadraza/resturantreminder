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
    
    @IBOutlet weak var placeHolderUserNameLabel: UILabel!
    @IBOutlet weak var placeHolderUserProfileImageView: UIImageView!

    
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
    var numberOfNotifications = 0
    
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
        self.fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.userProfileImageView.cornerRadius = userProfileImageView.height/2
    }
    // MARK: - SETUP VIEW
    
    private func setupView() {
        registerTableViewCell()
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: .dismissAddRestaurant, object: nil)
    }
    
    
    @objc func fetchData() {
        self.fetchHomeData()
        self.fetchTodayNotifications()
    }
    
    private func fetchTodayNotifications() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        viewModel.fetchTodayNotification(userID: AppDefaults.currentUser?.userID ?? "", date: dateFormatter.string(from: Date())) { notificationDict in
            if let notificationDict = notificationDict {
                if let todayNotifCount = notificationDict[dateFormatter.string(from: Date())] {
                    AppDefaults.numberOfNotifications = todayNotifCount
                } else {
                    self.viewModel.removeNumOfNotifications(userID: AppDefaults.currentUser?.userID ?? "")
                    self.fetchNotificationsCountFromSettings()
                }
            } else {
                self.fetchNotificationsCountFromSettings()
                
            }
        }
    }
    
    private func fetchNotificationsCountFromSettings() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        
        viewModel.fetchSettingsData { data, errorMsg in
            if let errorMsg = errorMsg {
                Snackbar.showSnackbar(message: errorMsg, duration: .middle)
            }
            if let data = data {
                guard let numberOfNotif = data.numberOfNotifications else { return }
                self.viewModel.addTodayNotification(userID: AppDefaults.currentUser?.userID ?? "", date: dateFormatter.string(from: Date()), count: numberOfNotif)
                //                completion(numberOfNotif)
            }
        }
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
            self.userNameLabel.text = "Hey, \(AppDefaults.currentUser?.fullName ?? "")"
            self.placeHolderUserNameLabel.text = "Hey, \(AppDefaults.currentUser?.fullName ?? "")"
        }
        
        self.viewModel.fetchProfilePicture { (image, _) in
            if let image = image {
                self.userProfileImageView.image = image
                self.placeHolderUserProfileImageView.image = image
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
        let count = self.categories.count + 1
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.HomeTableViewCell, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.row == 0 {
            cell.configureCell(model: self.restaurant, categoryTitle: "All Restaurants", categorySubTitle: "", restaurantImages: self.restaurantImages)
        }
        else {
            var restaurantModel = [ResturantModel]()
            var restaurantImage = [String: UIImage]()

            self.restaurant.forEach { object in
                if object.categories?.contains(self.categories[indexPath.row - 1]) ?? false {
                    restaurantModel.append(object)
                    self.restaurantImages.forEach { (key, value) in
                        if object.restaurantID == key {
                            restaurantImage[key] = value
                        }
                    }
                    cell.configureCell(model: restaurantModel, categoryTitle: indexPath.row == 1 ? "All Categories" : "", categorySubTitle: self.categories[indexPath.row - 1], restaurantImages: restaurantImage)
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
