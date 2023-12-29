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
            print("【AccountDataBase】create table error \(error)")
        }
        
        database.setAutoMigration(enable: true)
    }
    
    func getAllData() -> Array<Account> {
        do {
            let objects: [Account] = try database.getObjects(fromTable: AccountDataBase.tableName, orderBy: [Account.Properties.createTime.order(.descending)])
            for data in objects {
                self.updataData(data: data)
            }
            return objects
        } catch {
            print("【AccountDataBase】get all data error \(error)")
        }
        return []
    }
    
    func getData(accountName: String) -> Account? {
        do {
            let object: Account? = try database.getObject(fromTable: AccountDataBase.tableName, where: Account.Properties.accountName == accountName)
            return object
        } catch {
            print("【AccountDataBase】get data error \(error)")
        }
        return nil
    }
    
    @discardableResult
    func insertData(data: Account) -> Bool {
        do {
            try database.insert(data, intoTable: AccountDataBase.tableName)
            return true
        } catch {
            print("【AccountDataBase】insert data error \(error)")
            return false
        }
    }
    
    @discardableResult
    func insertOrReplaceData(data: Account) -> Bool {
        do {
            try database.insertOrReplace(data, intoTable: AccountDataBase.tableName)
            return true
        } catch {
            print("【AccountDataBase】insert or replace data error \(error)")
            return false
        }
    }
    
    @discardableResult
    func deleteData(accountName: String) -> Bool {
        do {
            try database.delete(fromTable: AccountDataBase.tableName,
                                where: Account.Properties.accountName == accountName)
            return true
        } catch {
            print("【AccountDataBase】delete data error \(error)")
            return false
        }
    }
    
    func updataData(data: Account) {
        if let string = data.externString {
            if let jsonData = string.data(using: .utf8) {
                do {
                    if let dict = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? Dictionary<String, String> {
                        data.externDict = dict
                        data.externString = nil
                        self.insertOrReplaceData(data: data)
                    }
                } catch {
                    print("【AccountDataBase】update old database data error: \(error)")
                }
            }
        }
    }
}

