//
//  MainTabBar.swift
//  ResturantReminder
//
//  Created by Mehdi Haider on 08/12/2021.
//

import UIKit

class MainTabBar: UITabBar {
    
    var viewCustomTabBar: UIView?
    
    override func point(inside point: CGPoint, with _: UIEvent?) -> Bool {
      if let centerButton = viewCustomTabBar {
        if centerButton.frame.contains(point) {
          return true
        }
      }
      
      return self.bounds.contains(point)
    }
    
}
