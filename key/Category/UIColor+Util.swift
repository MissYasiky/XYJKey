//
//  UIColor+Util.swift
//  key
//
//  Created by MissYasiky on 2023/11/8.
//  Copyright © 2023 netease. All rights reserved.
//

import Foundation
import UIKit

private let text_color: String = "0x343437"
private let line_color: String = "0xc1c2c2"
private let theme_blue_color: String = "0x5392dc"
private let theme_red_color: String = "0xdd5757"

extension UIColor {
    static let textColor: UIColor = UIColor.color(text_color)
    static let lineColor: UIColor = UIColor.color(line_color)
    static let themeBlue: UIColor = UIColor.color(theme_blue_color)
    static let themeRed: UIColor = UIColor.color(theme_red_color)
    
    class func textColor(alpha: CGFloat) -> UIColor {
        return UIColor.color(text_color, alpha: alpha)
    }
    
    class func lineColor(alpha: CGFloat) -> UIColor {
        return UIColor.color(line_color, alpha: alpha)
    }
    
    class func themeBlue(alpha: CGFloat) -> UIColor {
        return UIColor.color(theme_blue_color, alpha: alpha)
    }
    
    class func themeRed(alpha: CGFloat) -> UIColor {
        return UIColor.color(theme_red_color, alpha: alpha)
    }
    
    class func color(_ hexString: String) -> UIColor {
        return UIColor.color(hexString, alpha: 1.0)
    }
    
    class func color(_ hexString: String, alpha: Double) -> UIColor {
        guard hexString.count >= 6 else {
            return UIColor(white: 1, alpha: 1)
        }
        
        var rgbValue: UInt64 = 0
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.currentIndex = hexString.index(hexString.startIndex, offsetBy: 1)
        }
        scanner.scanHexInt64(&rgbValue)
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8)/255.0
        let blue = CGFloat(rgbValue & 0x0000FF)/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
