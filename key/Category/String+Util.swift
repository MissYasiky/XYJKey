//
//  String+Util.swift
//  key
//
//  Created by MissYasiky on 2023/11/30.
//  Copyright © 2023 netease. All rights reserved.
//

import Foundation

extension String {
    /**
     是否是纯数字字符串
     */
    func isNumber() -> Bool {
        let str = self.trimmingCharacters(in: CharacterSet.decimalDigits)
        return str.count == 0
    }
    
    /**
     返回字符串中的数字字符串
    */
    func scanNumber() -> String {
        var res = ""
        for c in self {
            if c >= "0" && c <= "9" {
                res.append(c)
            }
        }
        return res
    }
    
    /**
     只保留字符串中的数字，并将每四位数字用一个空格分隔开
     */
    func scanAndSeperateEveryFour() -> String {
        let str = self.scanNumber()
        var res = ""
        var i = 0
        while i < str.count {
            if i != 0 && i % 4 == 0 {
                res += " "
            }
            let index = str.index(str.startIndex, offsetBy: i)
            res += str[index...index]
            i += 1
        }
        return res
    }
}
