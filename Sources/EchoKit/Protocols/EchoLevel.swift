//
//  EchoLevel.swift
//
//
//  Created by Lukas on 4/29/24.
//
import Foundation

public protocol EchoLevel: CaseIterable {
    
    var echoLevel: Level { get }
    var filterKey: String? { get }
}

public enum LogLevel: String, Codable, EchoLevel {
    
    public var filterKey: String? {
        "GA"
    }
    
    public var echoLevel: Level {
        .warning
    }
    
    case network = "🤎 [NET]"
    case ga = "🖤 [GA]"
    case duration = "💚 [DURATION]"
    case verbose = "💜 [VERBOSE]"
    case info = "💙 [INFO]"
    case debug = "💛 [DEBUG]"
    case warning = "🧡 [WARNING]"
    case error = "❤️ [ERROR]"
    case assert = "💔 [ASSERT]"
    case fatal = "❤️‍🩹 [FATAL]"
}

open class Logger {
    
    private static var startTime: Int64 = 0
    
    public static func network(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        outputLog(logLevel: .network, message: message, file: file, function: function, line: line)
    }

    public static func ga(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        outputLog(logLevel: .ga, message: message, file: file, function: function, line: line)
    }

    public static func verbose(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        outputLog(logLevel: .verbose, message: message, file: file, function: function, line: line)
    }

    public static func debug(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        outputLog(logLevel: .debug, message: message, file: file, function: function, line: line)
    }

    public static func info(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        outputLog(logLevel: .info, message: message, file: file, function: function, line: line)
    }

    public static func warning(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        outputLog(logLevel: .warning, message: message, file: file, function: function, line: line)
    }
    
    public static func error(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        outputLog(logLevel: .error, message: message, file: file, function: function, line: line)
    }

    public static func assert(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        outputLog(logLevel: .assert, message: message, file: file, function: function, line: line)
    }

    public static func fatal(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        outputLog(logLevel: .fatal, message: message, file: file, function: function, line: line)
    }

    public static func start() {
        
        startTime = Date().millisecondsSince1970
    }
    
    public static func duration(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        
        let current = Date().millisecondsSince1970
        outputLog(logLevel: .duration, message: message, file: file, function: function, line: line, duration: Double(current - startTime) / 1000.0)
        
        startTime = 0
    }

    public static func outputLog(logLevel: LogLevel, message: Any, file: String, function: String, line: Int, duration: Double = 0) {
        #if DEBUG
        printToConsole(logLevel: logLevel, message: message, file: file, function: function, line: line, duration: duration)
        guard let message = message as? String else { return }
        Console.echo(message, level: logLevel)
        #endif
    }
    
    static func printToConsole(logLevel: LogLevel, message: Any, file: String, function: String, line: Int, duration: Double) {
        
        let fileComponents = file.components(separatedBy: "/")
        var file = fileComponents.last ?? ""
        if let range = file.range(of: ".swift") {
            file.replaceSubrange(range, with: "")
        }
        
        let codePosition = file + "(L#" + String(line) + ") " + function
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let logHeader = formatter.string(from: date) + " "+logLevel.rawValue+" "+codePosition+" : "
        
        print(logHeader, terminator: "")
        
        var logMessage = message as? CVarArg ?? ""
        if logLevel == .duration {
            logMessage = String("[\(duration) s] \(message)")
        }
        print(logMessage)
        
        DispatchQueue.main.async {
            self.afterPrint(logLevelValue: logLevel.rawValue, log: String(format: "%@\n>> %@", logMessage, codePosition))
        }
    }
    
    open class func afterPrint(logLevelValue: String, log: String) {
    }
}

extension Date {
    var millisecondsSince1970:Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}
