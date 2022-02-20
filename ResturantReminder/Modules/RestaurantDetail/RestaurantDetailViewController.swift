//
//  RestaurantDetailViewController.swift
//  ResturantReminder
//
//  Created by Faraz on 1/10/22.
//

import UIKit

class RestaurantDetailViewController: UIViewController {

    //MARK: - OUTLETS & VARIABLES
    
    @IBOutlet weak var restaurantTitleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var restaurantModel: ResturantModel?
    var titleImage : UIImage?
    
    //MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViews()
    }

    //MARK: - UPDATE VIEWS
    
    private func updateViews() {
        if let titleImage = titleImage {
            self.restaurantTitleImage.image = titleImage
        }
        if let restaurantModel = restaurantModel {
//            self.restaurantTitleImage.image = UIImage()
            self.titleLabel.text = restaurantModel.name ?? "N/A"
            self.distanceLabel.text = "N/A"
            self.ratingLabel.text = "\(restaurantModel.rating ?? 0.0)"
            self.descriptionLabel.text = restaurantModel.notes ?? "N/A"
        }
    }
    
    //MARK: - ACTIONS

    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func silentNotificationTapped(_ sender: UIButton) {
        
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
