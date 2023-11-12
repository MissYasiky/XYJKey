//
//  FontUtil.swift
//  key
//
//  Created by MissYasiky on 2023/11/12.
//  Copyright © 2023 netease. All rights reserved.
//

import Foundation
import UIKit

private let regular: String = "PingFangSC-Regular"
private let bold: String = "PingFangSC-Semibold"

class FontUtil {
    class func regularFont(size: CGFloat) -> UIFont? {
        return UIFont(name: regular, size: size)
    }
    
    class func boldFont(size: CGFloat) -> UIFont? {
        return UIFont(name: bold, size: size)
    }
}
