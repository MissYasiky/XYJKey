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
        let path = paths[0] + "/db_card.db"
        database = Database(at: path)
        print(path)
        do {
            try database.create(table: CardDataBase.tableName, of: Card.self)
        } catch {
            print("create CardDataBase tableName error");
        }
    }
    
    func getAllData() -> Array<Card> {
        do {
            let objects: [Card] = try database.getObjects(fromTable: CardDataBase.tableName)
            return objects
        } catch {
            print("error")
        }
        return []
    }
    
    func insertData(data: Card) -> Bool {
        do {
            try database.insert(data, intoTable: CardDataBase.tableName)
            return true
        } catch {
            return false
        }
    }
    
    func insertOrReplaceData(data: Card) -> Bool {
        do {
            try database.insertOrReplace(data, intoTable: CardDataBase.tableName)
            return true
        } catch {
            return false
        }
    }
    
    func deleteData(createTime: TimeInterval) -> Bool {
        do {
            try database.delete(fromTable: CardDataBase.tableName,
                                where: Card.Properties.createTime == createTime)
            return true
        } catch {
            return false
        }
    }
}
