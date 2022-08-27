//
//  RestaurantDetailViewController.swift
//  ResturantReminder
//
//  Created by Faraz on 1/10/22.
//

import UIKit
import Presentr

class RestaurantDetailViewController: UIViewController {

    //MARK: - OUTLETS & VARIABLES
    
    @IBOutlet weak var restaurantTitleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var restaurantModel: ResturantModel?
    var titleImage : UIImage?
    var notifRestaurantID: String?
    var restaurantHasItsOwnImage: Bool = false
    
    //MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchNotifRestaurant()
    }

    //MARK: - UPDATE VIEWS
    
    private func updateViews() {
        if let titleImage = titleImage {
            let dummyImage = UIImage.init(named: "NoImage-Placeholder")
            restaurantHasItsOwnImage = titleImage != dummyImage
            self.restaurantTitleImage.image = titleImage
        }
        if let restaurantModel = restaurantModel {
//            self.restaurantTitleImage.image = UIImage()
            self.titleLabel.text = restaurantModel.name ?? "N/A"
            self.distanceLabel.text = "N/A"
            self.ratingLabel.text = "\(String(describing: restaurantModel.rating?.roundTo(places: 1) ?? 0.0))"
            self.descriptionLabel.text = restaurantModel.notes ?? ""
            self.addressLabel.text = restaurantModel.address ?? ""
        }
    }
    
    //MARK: - FETCH DATA
    
    fileprivate func fetchNotifRestaurant() {
        guard let notifRestaurantID = notifRestaurantID else {
            self.updateViews()
            return
        }
        FirebaseManager.shared.fetchSingleResturant(userID: UserModel.shared.userID, resturantID: notifRestaurantID) { (model, _) in
            if let model = model {
                self.restaurantModel = model
                self.updateViews()
            }
        }
    }
    
    //MARK: - ACTIONS

    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editRestaurantTapped(_ sender: UIButton) {
        let vc = AddResturantViewController.initFromStoryboard(name: Constants.Storyboards.main)
        let presenter = Presentr.init(presentationType: .custom(width: .fluid(percentage: 1.0),
                                                                height: .fluid(percentage: 0.9), center: .center))
        presenter.dismissOnSwipe = true
        presenter.roundCorners = true
        presenter.cornerRadius = 10.0
        vc.titleText = "Edit Restaurant"
        vc.restaurantModel = self.restaurantModel
        vc.restaurantHasItsOwnImageForEditState = self.restaurantHasItsOwnImage
        vc.navigateBackToHome = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        customPresentViewController(presenter, viewController: vc, animated: true)
    }
    
    @IBAction func deleteRestaurantTapped(_ sender: UIButton) {
        
        Alert.showConfirmationAlert(vc: self, title: "Delete Restaurant", message: "Are you sure you want to delete?", alertPrederredStyle: .alert, actionTitle1: "Yes", actionTitle2: "No", actionStyle1: .destructive, actionStyle2: .cancel) { _ in
            FirebaseManager.shared.deleteRestaurant(userID: AppDefaults.currentUser?.userID ?? "", restaurantID: self.restaurantModel?.restaurantID ?? "")
            
            self.navigationController?.popViewController(animated: true)
        } handler2: { _ in
            //do nothing
        }
//        if let coordinates = self.restaurantModel?.coordinates {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.stopRegionMonitoring(center: coordinates, identifier: self.restaurantModel?.restaurantID ?? "")
//        }
//        NotificationManager.shared.triggerRandomNotification(identifier: "123", timeInterval: 10)
    }
}

extension RestaurantDetailViewController: StoryboardInitializable {}
