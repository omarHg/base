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
    case appName = "Application-Name"
    case appVersion = "App-Version"
    case appVersionContext = "appVersion"
    case authorization = "Authorization"
    case cacheControl = "Cache-Control"
    case contentType = "Content-Type"
    case deviceType = "Device-Type"
    case forwarded = "X-Forwarded-For"
    case identityApp = "GBMDigitalIdentityApp"
    case latitude = "device-latitude"
    case longitude = "device-longitude"
    case mfaCode = "X-MFA-CODE"
    case mobilePlatform = "Mobile-Platform"
    case osVersion = "Os-Version"
    case platform = "Platform"
    case profileSessionId = "Profile-Session-Id"
    case requestId = "x-amzn-RequestId"
    case device = "device"
    case macAddress = "device-mac-address"
    case status = "status"
    case context = "context"
    case userId = "userId"
    case connection = "Connection"
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
