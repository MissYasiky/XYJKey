//
//  card.swift
//  key
//
//  Created by MissYasiky on 2023/11/6.
//  Copyright © 2023 netease. All rights reserved.
//

import Foundation
import WCDBSwift

@propertyWrapper
struct digitalString {
    private var value: String?
    var wrappedValue: String? {
        get { return value }
        set {
            if let temp = newValue {
                var result: String = ""
                for c in temp {
                    if c >= "0" && c <= "9" {
                        result += String(c)
                    }
                }
                value = (result.isEmpty ? nil : result)
            } else {
                value = nil
            }
        }
    }
}

@propertyWrapper
struct validThruString {
    private var value: String?
    var wrappedValue: String? {
        get { return value }
        set {
            if let temp = newValue {
                var result: String = ""
                for c in temp {
                    if c >= "0" && c <= "9" {
                        result += String(c)
                        if result.count == 4 {
                            break
                        }
                    }
                }
                value = (result.count == 4 ? result : nil)
            } else {
                value = nil
            }
        }
    }
}

@propertyWrapper
struct threeDigitalString {
    private var value: String?
    var wrappedValue: String? {
        get { return value }
        set {
            if let temp = newValue {
                var result: String = ""
                for c in temp {
                    if c >= "0" && c <= "9" {
                        result += String(c)
                        if result.count == 3 {
                            break
                        }
                    }
                }
                value = (result.count == 3 ? result : nil)
            } else {
                value = nil
            }
        }
    }
}

@objc public final class Card: NSObject, TableCodable {
    @objc public var createTime: TimeInterval = NSDate().timeIntervalSince1970 * 1000
    @objc public var isCreditCard: Bool = false
    @objc public var isOwn: Bool = true
    
    @objc public var bankName: String? = nil
    @objc public var externDict: Dictionary<String, String>? = nil
    
    @objc public var accountNum: String? = nil
    @objc public var validThru: String? = nil
    @objc public var cvv2: String? = nil
    
//    @digitalString var accountNum: String?
//    @validThruString var validThru: String?
//    @threeDigitalString var cvv2: String?
    
    public enum CodingKeys: String, CodingTableKey {
        public typealias Root = Card
        public static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(createTime, isPrimary: true, orderBy:.descending)
        }
        
        case createTime
        case isCreditCard
        case isOwn
        case bankName
        case externDict
        case accountNum
        case validThru
        case cvv2
    }

    @objc public var cardType: String {
        get {
            return isCreditCard ? "信用卡" : "借记卡"
        }
    }

    @objc public var cardOwner: String {
        get {
            return isOwn ? "XIE YUN JIA" : "OTHER"
        }
    }

    @objc public var formatedValidThru: String? {
        get {
            if let temp = validThru {
                if temp.isEmpty {
                    return nil
                } else if temp.count <= 2 {
                    return temp
                } else {
                    let startIndex = temp.startIndex
                    let endIndex = temp.endIndex
                    let seprateIndex = temp.index(startIndex, offsetBy: 2)
                    return temp[startIndex..<seprateIndex] + "/" + temp[seprateIndex..<endIndex]
                }
            }
            return nil
        }
    }
}
