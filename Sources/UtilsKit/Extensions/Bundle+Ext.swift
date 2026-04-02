//
//  Bundle+Ext.swift
//  Base
//
//  Created by Omar Hernandez Gonzalez on 03/03/26.
//

import Foundation

public extension Bundle {
    var name: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
    var appVersion: String {
        let version = infoDictionary?["CFBundleVersion"] as? String
        return version ?? ""
    }
    
    var appShortVersion: String {
        let version = infoDictionary?["CFBundleShortVersionString"] as? String
        return version ?? ""
    }
}
