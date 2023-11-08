//
//  AccountDataBase.swift
//  key
//
//  Created by MissYasiky on 2023/11/7.
//  Copyright © 2023 netease. All rights reserved.
//

import Foundation
import WCDBSwift

@objc public final class AccountDataBase: NSObject {
    static let tableName = "AccountTable"
    let database: Database
    
    @objc public static let shared = AccountDataBase()
    private override init() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] + "/account.db"
        database = Database(at: path)
        do {
            try database.create(table: AccountDataBase.tableName, of: Account.self)
        } catch {
            print("create AccountDataBase tableName error");
        }
    }
    
    @objc public func getAllData() -> Array<Account> {
        do {
            let objects: [Account] = try database.getObjects(fromTable: AccountDataBase.tableName)
            return objects
        } catch {
            print("error")
        }
        return []
    }
    
    @objc public func insertData(data: Account) -> Bool {
        do {
            try database.insert(data, intoTable: AccountDataBase.tableName)
            return true
        } catch {
            return false
        }
    }
    
    @objc public func insertOrReplaceData(data: Account) -> Bool {
        do {
            try database.insertOrReplace(data, intoTable: AccountDataBase.tableName)
            return true
        } catch {
            return false
        }
    }
    
    @objc public func deleteData(createTime: TimeInterval) -> Bool {
        do {
            try database.delete(fromTable: AccountDataBase.tableName,
                                where: Account.Properties.createTime == createTime)
            return true
        } catch {
            return false
        }
    }
}

