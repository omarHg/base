//
//  APIError.swift
//  LinkMe
//
//  Created by Omar Hernandez Gonzalez on 15/09/26.
//

import Foundation

public enum APIError: LocalizedError {
    case invalidURL
    case requestFailed(statusCode: Int)
    case invalidData
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL: return "The URL provided was invalid."
        case .requestFailed(let code): return "The request failed with status code: \(code)."
        case .invalidData: return "The data received from the server was invalid or unparseable."
        }
    }
}
