//
//  Logger.swift
//  EchoKit-Demo
//
//  Created by Lukas on 5/3/24.
//

import EchoKit

enum LogLevel: String, Codable, EchoLevel {
    case network
    case ga
    case verbose
    case info
    case debug
    case warning
    case error
    case assert
    case fatal
    
    public var filterKey: String? {
        rawValue
    }
    
    public var echoLevel: Level {
        switch self {
        case .network:
            return .trace
        case .ga:
            return .info
        case .verbose:
            return .debug
        case .info:
            return .info
        case .debug:
            return .debug
        case .warning:
            return .warning
        case .error:
            return .error
        case .assert:
            return .critical
        case .fatal:
            return .critical
        }
    }
}

final class Logger {
    
    private static var startTime: Int64 = 0
    
    static func log(level: LogLevel, message: Any) {
        guard let message = message as? String else { return }
        Console.echo(message, level: level)
    }
}
