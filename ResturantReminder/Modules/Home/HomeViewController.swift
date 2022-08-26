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
        self.tableView.isHidden = true
        self.noRestaurantLabel.isHidden = true
//        setupLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !(AppDefaults.notifRestaurantID.isEmpty) {
            let vc = RestaurantDetailViewController.initFromStoryboard(name: Constants.Storyboards.main)
            vc.notifRestaurantID = AppDefaults.notifRestaurantID
            AppDefaults.notifRestaurantID = ""
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.fetchData()
        }
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
    }
    
    
    private func registerTableViewCell() {
        self.tableView.register(UINib.init(nibName: Constants.CellIdentifiers.HomeTableViewCell,
                                           bundle: .main),
                                forCellReuseIdentifier: Constants.CellIdentifiers.HomeTableViewCell)
    }
    
    // MARK: - FETCH DATA
    
    private func fetchHomeData() {
        UIApplication.startActivityIndicator(with: "")

        self.viewModel.fetchProfilePicture { (image, _) in
            if let image = image {
                self.userProfileImageView.image = image
                self.placeHolderUserProfileImageView.image = image
            }
        }

        viewModel.fetchResturant(userID: AppDefaults.currentUser?.userID ?? "") { restaurantModel, error in
            self.restaurant = self.viewModel.restaurant
            self.categories = self.viewModel.categories
            self.restaurantImages = self.viewModel.restaurantImages
            self.tableView.isHidden = self.restaurant.isEmpty
            self.noRestaurantLabel.isHidden = !self.restaurant.isEmpty
            self.startRegionMonitoringIfComingFromLogin()
            self.userNameLabel.text = "Hey, \(AppDefaults.currentUser?.fullName ?? "")"
            self.placeHolderUserNameLabel.text = "Hey, \(AppDefaults.currentUser?.fullName ?? "")"
            self.tableView.reloadData()
            UIApplication.stopActivityIndicator()
        }
    }

    private func startRegionMonitoringIfComingFromLogin() {
        if AppDefaults.fromLogin {
            self.restaurant.forEach { restaurant in
                guard let latitude = restaurant.location?.latitude else { return }
                guard let longitude = restaurant.location?.longitude else { return }
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
                appDelegate.monitorRegionAtLocation(center: coordinates, identifier: restaurant.restaurantID ?? "")
            }
            AppDefaults.fromLogin = false
        }
    }
    
    // MARK: - BUTTON ACTIONS
    
    @IBAction func profileButtonTapped(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }
    
    // MARK: - HELPER METHODS

}


extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.HomeTableViewCell, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.row == 0 {
            cell.configureCell(model: self.restaurant, categoryTitle: "All Restaurants", categorySubTitle: "", restaurantImages: self.restaurantImages)
        }
        else {
            let category = self.categories[indexPath.row - 1]
            let resturantForCategory = self.viewModel.restaurantModelBasedOnCategories[category] ?? []
            let resturantImagesForCategory = self.viewModel.restaurantImageBasedOnCategories[category] ?? [:]
            cell.configureCell(model: resturantForCategory,
                               categoryTitle: indexPath.row == 1 ? "All Categories" : "",
                               categorySubTitle: category,
                               restaurantImages: resturantImagesForCategory)
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
