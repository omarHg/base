//
//  ApiHeaderKey.swift
//  LinkMe
//
//  Created by Omar Hernandez Gonzalez on 15/09/26.
//

import Foundation

public enum ApiHeaderKey: String {
    case accept = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case authorization = "Authorization"
    case cacheControl = "Cache-Control"
    case contentType = "Content-Type"
    case platform = "Platform"
    case status = "status"
    case context = "context"
    case connection = "Connection"
    case latitude = "device-latitude"
    case longitude = "device-longitude"
}

public struct ApiHeaderValue {
    public static let bearerFormat = "Bearer %@"
    public static let gzipDeflateBr = "gzip, deflate, br"
    public static let gzip = "gzip"
    public static let keepAlive = "keep-alive"
    public static let identityAppValue = "3"
    public static let iOS = "iOS"
    public static let jsonText = "*/*"
    public static let applicationJson = "application/json"
    public static let textPlain = "text/plain"
    public static let jsonCharset = "application/json; charset=UTF-8"
    public static func bearerToken(_ token: String) -> String {
        String(format: bearerFormat, token)
    }
}
