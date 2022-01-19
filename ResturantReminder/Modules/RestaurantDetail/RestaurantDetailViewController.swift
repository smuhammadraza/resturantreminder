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
    
    //MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViews()
    }

    //MARK: - UPDATE VIEWS
    
    private func updateViews() {
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
        FirebaseManager.shared.deleteRestaurant(userID: AppDefaults.currentUser?.userID ?? "", restaurantID: self.restaurantModel?.restaurantID ?? "")
        NotificationManager.shared.triggerRandomNotification(identifier: "123", timeInterval: 10)
        self.navigationController?.popViewController(animated: true)
    }
}

extension RestaurantDetailViewController: StoryboardInitializable {}
