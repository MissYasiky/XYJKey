//
//  CardDataBase.swift
//  key
//
//  Created by MissYasiky on 2023/11/7.
//  Copyright © 2023 netease. All rights reserved.
//

import Foundation
import WCDBSwift

final class CardDataBase: NSObject {
    static let tableName = "CardTable"
    let database: Database
    
    static let shared = CardDataBase()
    private override init() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let sourcePath = paths[0] + "/db_card.db"
        
        // 创建迁移数据的目标数据库
        let targetPath = paths[0] + "/card.db"
        database = Database(at: targetPath)
        // 数据迁移配置
        // targetDatabase中的所有表格都调用这个回调，需要迁移的表格需要配置 sourceTable 和 sourceDatabase
        // 这个配置需要在所有targetDatabase数据操作前配置
        database.filterMigration({ info in
            if info.table == CardDataBase.tableName {
                info.sourceDatabase = sourcePath
                info.sourceTable = "XYJCard"
            }
        })
        print(targetPath)
        do {
            try database.create(table: CardDataBase.tableName, of: Card.self)
        } catch {
            print("【CardDataBase】create table error \(error)")
        }
        
        database.setAutoMigration(enable: true)
    }
    
    func getAllData() -> Array<Card> {
        do {
            let objects: [Card] = try database.getObjects(fromTable: CardDataBase.tableName, orderBy: [Card.Properties.createTime.order(.descending)])
            for data in objects {
                self.updataData(data: data)
            }
            return objects
        } catch {
            print("【CardDataBase】get all data error \(error)")
        }
        return []
    }
    
    func getData(accountNum: String) -> Card? {
        do {
            let object: Card? = try database.getObject(fromTable: CardDataBase.tableName, where: Card.Properties.accountNum == accountNum)
            return object
        } catch {
            print("【CardDataBase】get data error \(error)")
        }
        return nil
    }
    
    @discardableResult
    func insertData(data: Card) -> Bool {
        do {
            try database.insert(data, intoTable: CardDataBase.tableName)
            return true
        } catch {
            print("【CardDataBase】insert data error \(error)")
            return false
        }
    }
    
    @discardableResult
    func insertOrReplaceData(data: Card) -> Bool {
        do {
            try database.insertOrReplace(data, intoTable: CardDataBase.tableName)
            return true
        } catch {
            print("【CardDataBase】insert or replace data error \(error)")
            return false
        }
    }
    
    @discardableResult
    func deleteData(accountNum: String) -> Bool {
        do {
            try database.delete(fromTable: CardDataBase.tableName,
                                where: Card.Properties.accountNum == accountNum)
            return true
        } catch {
            print("【CardDataBase】delete data error \(error)")
            return false
        }
    }
    
    func updataData(data: Card) {
        if let string = data.externString {
            if let jsonData = string.data(using: .utf8) {
                do {
                    if let dict = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? Dictionary<String, String> {
                        data.externDict = dict
                        data.externString = nil
                        self.insertOrReplaceData(data: data)
                    }
                } catch {
                    print("【CardDataBase】update old database data error: \(error)")
                }
            }
        }
    }
}
