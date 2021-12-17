//
//  Utilities.swift
//  Carzaty
//
//  Created by Raza Naqvi on 07/12/2018.
//  Copyright © 2018 Hassan. All rights reserved.
//

import Foundation
import UIKit

enum UIUserInterfaceIdiom : Int {
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize {
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType {
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPHONE_XS_MAX     = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad
    
}

class Utilities {
    
    class func convertIphone6ToIphone5_Width(size : CGFloat) -> CGFloat{
        var tempSize = size;
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.bounds.width{
            case 320:
                // //////print("iPhone 4 or 4S")
                tempSize = ( size * 84.5 ) / 100 ;
            case 375:
                ////////print("iPhone 5 or 5S or 5C")
                tempSize = ( size * 100 ) / 100 ;
            case 414:
                ////////print("iPhone 6 or 6S")
                tempSize = ( size * 110.4 ) / 100 ;
            case 1104:
                // //////print("iPhone 6+ or 6S+")
                tempSize = ( size * 110.47 ) / 100 ;
            default:
                tempSize = ( size * 110.47 ) / 100 ;
                break
                //                //////print("", terminator: "")
            }
        }
        else{
            
            switch UIScreen.main.bounds.height {
            case 1024 :
                tempSize = (size * 125) / 100
            case 2732 :
                tempSize = (size * 187) / 100
            default: break
                //                //////print("other", terminator: "")
            }
            
            
        }
        
        return tempSize
    }
    
    class func convertIphone6ToIphone5(size : CGFloat) -> CGFloat {
        
        var tempSize = size;
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.bounds.height{
                
            case 260:
                ////////print("iPhone Classic")
                tempSize = ( size * 72.3 ) / 100 ;
            case 480:
                // //////print("iPhone 4 or 4S")
                tempSize = ( size * 72.3 ) / 100 ;
            case 568:
                ////////print("iPhone 5 or 5S or 5C")
                tempSize = ( size * 84.5 ) / 100 ;
            case 667:
                ////////print("iPhone 6 or 6S")
                tempSize = size;
            case 736:
                // //////print("iPhone 6+ or 6S+")
                tempSize = ( size * 110.47 ) / 100 ;
            case 812:
                // //////print("iPhone 6+ or 6S+")
                tempSize = ( size * 110.47 ) / 100 ;
            case 896:
                // //////print("iPhone XR or XS Max")
                //                tempSize = ( size * 134.33 ) / 100
                tempSize = ( size * 130.33 ) / 100
            default: break
                //                //////print("", terminator: "")
            }
        }
        else{
            
            switch UIScreen.main.bounds.height {
            case 1024 :
                tempSize = (size * 125) / 100
            case 2732 :
                tempSize = (size * 187) / 100
            default: break
                //                //////print("other", terminator: "")
            }
            
        }
        
        return tempSize
}
    
    
   
    
    
    

}
