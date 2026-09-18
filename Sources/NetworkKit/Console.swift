//
//  Console.swift
//  LinkMe
//
//  Created by Omar Hernandez Gonzalez on 15/09/26.
//

import Foundation

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
