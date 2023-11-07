//
//  Account.swift
//  key
//
//  Created by MissYasiky on 2023/11/7.
//  Copyright © 2023 netease. All rights reserved.
//

import Foundation
import WCDBSwift

@objc public final class Account: NSObject, TableCodable {
    @objc public var createTime: TimeInterval = NSDate().timeIntervalSince1970 * 1000
    @objc public var accountName: String? = nil
    @objc public var externDict: Dictionary<String, String>? = nil
    
    public enum CodingKeys: String, CodingTableKey {
        public typealias Root = Account
        public static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(createTime, isPrimary: true, orderBy:.descending)
        }
        
        case createTime
        case accountName
        case externDict
    }
}
