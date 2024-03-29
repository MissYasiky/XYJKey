//
//  Account.swift
//  key
//
//  Created by MissYasiky on 2023/11/7.
//  Copyright © 2023 netease. All rights reserved.
//

import Foundation
import WCDBSwift

final class Account: NSObject, TableCodable {
    var createTime: TimeInterval = NSDate().timeIntervalSince1970 * 1000
    var accountName: String? = nil
    var externString: String? = nil
    var externDict: Dictionary<String, String>? = nil
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = Account
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(accountName, isPrimary: true, isNotNull:true, isUnique: true)
            BindIndex(createTime, namedWith: "_index")
        }
        
        case createTime
        case accountName
        case externString
        case externDict
    }
}
