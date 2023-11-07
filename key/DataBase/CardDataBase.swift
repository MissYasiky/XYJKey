//
//  CardDataBase.swift
//  key
//
//  Created by MissYasiky on 2023/11/7.
//  Copyright © 2023 netease. All rights reserved.
//

import Foundation
import WCDBSwift

final class CardDataBase {
    static let tableName = "CardTable"
    let database: Database
    
    static let shared = CardDataBase()
    private init() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] + "/card.db"
        database = Database(withPath: path)
        database.create(table: CardDataBase.tableName, of: Card.self)
    }
    
    func getAllData() -> Array<Card> {
        let objects: [Card] = try database.getObjects(fromTable: CardDataBase.tableName)
        return
    }
    
    func insertData(data: Card) {
        try database.insert(objects: data, intoTable: CardDataBase.tableName)
    }
    
    func insertOrReplaceData(data: Card) {
        try database.insertOrReplace(objects: data, intoTable: CardDataBase.tableName)
    }
    
    func deleteData(createTime: NSTimeInterval) {
        try database.delete(fromTable: CardDataBase.tableName,
                            where: Card.Properties.createTime == createTime)
    }
}
