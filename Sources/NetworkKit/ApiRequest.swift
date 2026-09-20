//
//  ApiRequest.swift
//  LinkMe
//
//  Created by Omar Hernandez Gonzalez on 15/09/26.
//

import Foundation

public struct ApiRequest: Hashable {
    public private(set) var url: URL
    private(set) var method: HTTPMethod
    private(set) var headers: [ApiHeaderKey: String] = Self.baseHeaders
    private(set) var body: Data?
    private(set) var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData
    private(set) var timeout: TimeInterval = 60
    private(set) var token: String?
    private(set) var requireToken: Bool = true
    
    public init(url: URL, method: HTTPMethod) {
        self.url = url
        self.method = method
    }
    
    public func encodeBody<T: Encodable>(_ body: T) -> ApiRequest {
        var copy = self
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            encoder.dateEncodingStrategy = .customEncodeDate
            copy.body = try encoder.encode(body)
        } catch {
            
        }
        return copy
    }
    
    public func encodeDynamicBody(_ body: [String: Any]) -> ApiRequest {
        var copy = self
        do {
            copy.body = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            Console.logError("Error al serializar el cuerpo dinámico: \(error)")
        }
        return copy
    }
    
    func build() -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeout)
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key.rawValue)
        }
        request.httpBody = body
        request.httpMethod = method.rawValue
        Console.logApi(headers.debugDescription)
        return request
    }
}

// MARK: - Header modifiers
public extension ApiRequest {
    func keyHeaders() -> ApiRequest {
        var copy = self
        copy.requireToken = false
        copy.headers = Self.keyHeaders
        return copy
    }
    
    func token(_ token: String?) -> ApiRequest {
        var copy = self
        copy.token = token
        if requireToken, let token = token {
            copy.headers[.authorization] = ApiHeaderValue.bearerToken(token)
        }
        return copy
    }
    
    func ignoringToken() -> ApiRequest {
        var copy = self
        copy.requireToken = false
        copy.headers[.authorization] = nil
        return copy
    }
    
    func latitude(_ latitude: String) -> ApiRequest {
        var copy = self
        copy.headers[.latitude] = latitude
        return copy
    }
    
    func longitude(_ longitude: String) -> ApiRequest {
        var copy = self
        copy.headers[.longitude] = longitude
        return copy
    }
    
}

// MARK: - HTTPMethod initializers
public extension ApiRequest {
    static func get(_ url: URL) -> ApiRequest {
        return ApiRequest(url: url, method: .GET)
    }
    static func post(_ url: URL) -> ApiRequest {
        return ApiRequest(url: url, method: .POST)
    }
    static func put(_ url: URL) -> ApiRequest {
        return ApiRequest(url: url, method: .PUT)
    }
    static func delete(_ url: URL) -> ApiRequest {
        return ApiRequest(url: url, method: .DELETE )
    }
    static func patch(_ url: URL) -> ApiRequest {
        return ApiRequest(url: url, method: .PATCH)
    }
}

extension ApiRequest {
    static var keyHeaders: [ApiHeaderKey: String] {
        [
            .accept: ApiHeaderValue.jsonText,
            .contentType: ApiHeaderValue.jsonCharset
        ]
    }
    
    static var baseHeaders: [ApiHeaderKey: String] {
        [
            .accept: ApiHeaderValue.jsonText,
            .acceptEncoding: ApiHeaderValue.gzipDeflateBr,
            .connection: ApiHeaderValue.keepAlive,
            .contentType: ApiHeaderValue.applicationJson,
        ]
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

extension JSONEncoder.DateEncodingStrategy {
    static let customEncodeDate = custom {
        var container = $1.singleValueContainer()
        try container.encode(Formatter.baseFormatCodable.string(from: $0))
    }
}

extension Formatter {
    static let baseFormatCodable: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "es_MX")
        formatter.timeZone = TimeZone(secondsFromGMT: .zero)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        return formatter
    }()
}
