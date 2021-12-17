//
//  Extension+UIImageView.swift
//  VenueVision
//
//  Created by Muhammad Raza on 8/6/19.
//  Copyright © 2019 Muhammad Raza. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setOverlay(withColor color: UIColor) {
        if let image = self.image?.withRenderingMode(.alwaysTemplate) {
            self.image = image
            self.tintColor = color
        }
    }
}

extension UIImageView {
  func enableZoom() {
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
    isUserInteractionEnabled = true
    addGestureRecognizer(pinchGesture)
  }

  @objc
  private func startZooming(_ sender: UIPinchGestureRecognizer) {
    let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
    guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
    sender.view?.transform = scale
    sender.scale = 1
  }
}

extension UIImage {

    public enum DataUnits: String {
        case byte, kilobyte, megabyte, gigabyte
    }

    func getSizeIn(_ type: DataUnits)-> String {
        guard let data = self.pngData() else { return "" }
        var size: Double = 0.0
        switch type {
        case .byte:
            size = Double(data.count)
        case .kilobyte:
            size = Double(data.count) / 1024
        case .megabyte:
            size = Double(data.count) / 1024 / 1024
        case .gigabyte:
            size = Double(data.count) / 1024 / 1024 / 1024
        }
        return String(format: "%.2f", size)
    }
}

