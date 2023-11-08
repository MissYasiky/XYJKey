//
//  SecrecyManager.swift
//  key
//
//  Created by MissYasiky on 2023/11/9.
//  Copyright © 2023 netease. All rights reserved.
//

import Foundation

@objc public class SecurityManager: NSObject {
    private static let unlockInterval: TimeInterval = 10
    private var lock:Bool = true
    private var unlockTimeInterval: TimeInterval = 0
    private var dateFormatter: DateFormatter = DateFormatter()
    
    @objc public static let shared = SecurityManager()
    private override init() {
        dateFormatter.dateFormat = "hhmm"
    }

    @objc public func isLock() -> Bool {
        if Date().timeIntervalSince1970 - unlockTimeInterval > SecurityManager.unlockInterval {
            lockAgain()
        }
        return lock
    }
    
    @objc public func isPasswordCorrect(_ password: String) -> Bool {
        if password.count != 4 {
            return false
        }
        let timeString = dateFormatter.string(from: Date())
        if let timeInt = Int(timeString), let passwordInt = Int(password) {
            return passwordInt - timeInt == 1204
        }
        return false
    }
    
    @objc public func unlockForSeconds() {
        lock = false
        unlockTimeInterval = Date().timeIntervalSince1970
    }
    
    private func lockAgain() {
        lock = true
    }
}
