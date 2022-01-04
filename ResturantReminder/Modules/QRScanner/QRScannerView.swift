//
//  QRScannerView.swift
//  ResturantReminder
//
//  Created by Faraz on 12/19/21.
//

import Foundation
import AVFoundation

class QRScannerView: UIView, QRCodeReaderDisplayable {
    var overlayView: QRCodeReaderViewOverlay?
    
    func setNeedsUpdateOrientation() {
        print("")
    }
    
    let cameraView: UIView            = UIView()
    let cancelButton: UIButton?       = UIButton()
    let switchCameraButton: UIButton? = SwitchCameraButton()
    let toggleTorchButton: UIButton?  = ToggleTorchButton()
//    var overlayView: UIView?          = UIView()
    
    func setupComponents(with builder: QRCodeReaderViewControllerBuilder) {
        // addSubviews
        // setup constraints
        // etc.
    }
}


