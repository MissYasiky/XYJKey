//
//  AccountDataBase.swift
//  key
//
//  Created by MissYasiky on 2023/11/7.
//  Copyright © 2023 netease. All rights reserved.
//

import Foundation
import WCDBSwift

final class AccountDataBase: NSObject {
    static let tableName = "AccountTable"
    let database: Database
    
    static let shared = AccountDataBase()
    private override init() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let sourcePath = paths[0] + "/db_account.db"
        
        // 创建迁移数据的目标数据库
        let targetPath = paths[0] + "/account.db"
        database = Database(at: targetPath)
        // 数据迁移配置
        // targetDatabase中的所有表格都调用这个回调，需要迁移的表格需要配置 sourceTable 和 sourceDatabase
        // 这个配置需要在所有targetDatabase数据操作前配置
        database.filterMigration({ info in
            if info.table == AccountDataBase.tableName {
                info.sourceDatabase = sourcePath
                info.sourceTable = "XYJAccount"
            }
        })
        
        do {
            try database.create(table: AccountDataBase.tableName, of: Account.self)
        } catch {
            print("create AccountDataBase tableName error");
        }
        
        database.setAutoMigration(enable: true)
    }
    
    func getAllData() -> Array<Account> {
        do {
            let objects: [Account] = try database.getObjects(fromTable: AccountDataBase.tableName, orderBy: [Account.Properties.createTime.order(.descending)])
            return objects
        } catch {
            print("error")
        }
        return []
    }
    
    func getData(accountName: String) -> Account? {
        do {
            let object: Account? = try database.getObject(fromTable: AccountDataBase.tableName, where: Account.Properties.accountName == accountName)
            return object
        } catch {
            print("error")
        }
        return nil
    }
    
    func insertData(data: Account) -> Bool {
        do {
            try database.insert(data, intoTable: AccountDataBase.tableName)
            return true
        } catch {
            return false
        }
    }
    
    func insertOrReplaceData(data: Account) -> Bool {
        do {
            try database.insertOrReplace(data, intoTable: AccountDataBase.tableName)
            return true
        } catch {
            return false
        }
    }
    
    func deleteData(accountName: String) -> Bool {
        do {
            try database.delete(fromTable: AccountDataBase.tableName,
                                where: Account.Properties.accountName == accountName)
            return true
        } catch {
            return false
        }
    }
}

