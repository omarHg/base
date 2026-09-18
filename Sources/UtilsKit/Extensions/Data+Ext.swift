//
//  Data+Ext.swift
//  Base
//
//  Created by Omar Hernandez Gonzalez on 18/09/26.
//

import Foundation

public extension Data {
    var jsonString: String {
        guard
            let json = try? JSONSerialization.jsonObject(with: self),
            let data = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted]),
            let string = String(data: data, encoding: .utf8)
        else {
            return String()
        }
        return string
    }
    
    var string: String {
        return String(data: self, encoding: .utf8) ?? String()
    }
}
