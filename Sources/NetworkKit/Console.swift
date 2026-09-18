//
//  Console.swift
//  LinkMe
//
//  Created by Omar Hernandez Gonzalez on 15/09/26.
//

import Foundation
import UtilsKit

public enum LogType: String, CaseIterable, Sendable {
    case info
    case error
    case api
}

public enum LogLevel: Sendable {
    case critical
    case `default`
}

public class Console {
    private static let configuration = ConsoleConfiguration()

    private static func log(message: String, type: LogType, fileId: String = #fileID) {
        guard configuration.isAllowed(type) else {
            return
        }
        let bundle = Bundle.main
        let module = fileId.components(separatedBy: "/")[.zero]
        print("\(bundle) [\(module)] [\(type.rawValue.capitalized)]: \(message)")
    }
    
    public static func logInfo(_ message: String, fileId: String = #fileID) {
        log(message: message, type: .info, fileId: fileId)
    }
    
    public static func logError(_ message: String, fileId: String = #fileID) {
        log(message: message, type: .error, fileId: fileId)
    }
    
    public static func logApi(_ message: String, fileId: String = #fileID) {
        log(message: message, type: .api, fileId: fileId)
    }
    
    public static func setLoggerLevel(_ level: LogLevel, enableApiRequests: Bool = false) {
        var types: [LogType]
        switch level {
        case .critical:
            types = [.error]
        case .default:
            types = [.error, .info]
        }
        if enableApiRequests {
            types.append(.api)
        }
        configuration.setAllowedTypes(types)
    }
}

private final class ConsoleConfiguration: @unchecked Sendable {
    private let lock = NSLock()
    private var allowedTypes = Set(LogType.allCases)

    func isAllowed(_ type: LogType) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return allowedTypes.contains(type)
    }

    func setAllowedTypes(_ types: [LogType]) {
        lock.lock()
        defer { lock.unlock() }
        allowedTypes = Set(types)
    }
}

extension Console {
    static func logApi(request: ApiRequest) {
        let method = request.method.rawValue
        let url = request.url.absoluteString
        let body = request.body?.string
        var message = "\nRequest: \(method) | \(url)"
        if let body = body {
            message += "\nBody: \(body)"
        }
        logApi(message)
    }
    
    static func logApiRetry(request: ApiRequest, number: Int) {
        let method = request.method.rawValue
        let url = request.url.absoluteString
        let body = request.body?.string
        var message = "\nRetry \(number) Request: \(method) | \(url)"
        if let body = body {
            message += "\nBody: \(body)"
        }
        logApi(message)
    }
    
    static func logApi(response: HTTPURLResponse, request: ApiRequest, data: Data) {
        let url = request.url.absoluteString
        let method = request.method.rawValue
        let statusCode = response.localizedStatusCode
        let data = data.string
        let message = """
        \nResponse: \(method) | \(statusCode) | \(url)
        Data: \(data)
        """
        logApi(message)
    }
    
    static func logApi(error: Error, request: ApiRequest, response: HTTPURLResponse?, data: Data?) {
        let url = request.url.absoluteString
        let method = request.method.rawValue
        let statusCode = response?.localizedStatusCode
        let data = data?.string ?? ""
        var message = "\nResponse: \(method)"
        if let statusCode = statusCode {
            message += " | \(statusCode)"
        }
        message += " | \(url)"
        message += "\nError: \(String(describing: error))"
        message += "\nData: \(data)"
        logApi(message)
    }
}

extension HTTPURLResponse {
    var localizedStatusCode: String {
        let localizedCode = statusCode == 200 ? "Ok" : HTTPURLResponse.localizedString(forStatusCode: statusCode)
        return String(statusCode) + " " + localizedCode
    }
    
    var requestId: String? {
        allHeaderFields[ApiHeaderKey.requestId.rawValue] as? String ??
        allHeaderFields[ApiHeaderKey.requestId.rawValue.lowercased()] as? String
    }
}
