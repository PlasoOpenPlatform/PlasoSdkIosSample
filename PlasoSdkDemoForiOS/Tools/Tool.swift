//
//  Tool.swift
//  PlasoStyleUpimeDemo
//
//  Created by liyang on 2021/1/18.
//  Copyright © 2021 plaso. All rights reserved.
//

import UIKit
import CommonCrypto

class Tool {
    
    static func sign(params: [String: Any]) -> String {
        let query = Tool.populateQueryStringFromParameter(params: params)
        let key = UserDefaults.standard.string(forKey: "PlasoAppKey") ?? ""
        let sign = SignUtil.calBase64Sha1(withData: query, withSecret: key)
        return query + "&signature=\(sign)"
    }
    
    static func populateQueryStringFromParameter(params: [String: Any]) -> String {
        var queryArray = [String]()
        params.forEach { (key, value) in
            queryArray.append("\(key)=\(value)")
        }
        queryArray.sort()
        return queryArray.joined(separator: "&")
    }
}
