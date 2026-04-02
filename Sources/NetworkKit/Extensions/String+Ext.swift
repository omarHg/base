//
//  String+Ext.swift
//  Base
//
//  Created by Omar Hernandez Gonzalez on 28/02/26.
//

import Foundation

public extension String {
    var utf8Data: Data {
        data(using: .utf8) ?? Data()
    }
}
