//
//  AccountDataBase.swift
//  key
//
//  Created by MissYasiky on 2023/11/7.
//  Copyright © 2023 netease. All rights reserved.
//

import Foundation
import WCDBSwift

final class AccountDataBase {
    static let tableName = "AccountTable"
    let database: Database
    
    static let shared = AccountDataBase()
    private init() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] + "/account.db"
        database = Database(withPath: path)
        database.create(table: AccountDataBase.tableName, of: Account.self)
    }
    
    func getAllData() -> Array<Account> {
        let objects: [Account] = try database.getObjects(fromTable: AccountDataBase.tableName)
        return
    }
    
    func insertData(data: Account) {
        try database.insert(objects: data, intoTable: AccountDataBase.tableName)
    }
    
    func insertOrReplaceData(data: Account) {
        try database.insertOrReplace(objects: data, intoTable: AccountDataBase.tableName)
    }
    
    func deleteData(createTime: NSTimeInterval) {
        try database.delete(fromTable: AccountDataBase.tableName,
                            where: Account.Properties.createTime == createTime)
    }
}

