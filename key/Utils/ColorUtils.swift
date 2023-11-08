//
//  ColorUtils.swift
//  key
//
//  Created by MissYasiky on 2023/11/8.
//  Copyright © 2023 netease. All rights reserved.
//

import Foundation
import UIKit

let text_color: String = "0x343437"
let line_color: String = "0xc1c2c2"
let theme_blue_color: String = "0x5392dc"
let theme_red_color: String = "0xdd5757"

class ColorUtils {
    class func color(_ hexString: String) -> UIColor {
        return ColorUtils.color(hexString, alpha: 1.0)
    }
    
    class func color(_ hexString: String, alpha: Double) -> UIColor {
        guard hexString.count >= 6 else {
            return UIColor(white: 1, alpha: 1)
        }
        
        var rgbValue: UInt64 = 0
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        scanner.scanHexInt64(&rgbValue)
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8)/255.0
        let blue = CGFloat(rgbValue & 0x0000FF)/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
