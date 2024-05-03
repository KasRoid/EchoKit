//
//  Level.swift
//
//
//  Created by Lukas on 4/19/24.
//

public enum Level: String, CaseIterable, CustomStringConvertible, EchoLevel {
    
    case notice    // Typically used to indicate less important messages that may be useful in tracking application flow.
    case info      // Provides general information about application processes, often used for regular operations.
    case debug     // Used for detailed debugging information, helpful during development to diagnose problems.
    case trace     // Offers more granular debugging information than `debug`, capturing step-by-step tracing of operations.
    case warning   // Indicates a possible issue or unexpected situation that isn't necessarily an error but might require attention.
    case error     // Represents a failure or issue that disrupts normal operation but doesn't cause the program to terminate.
    case fault     // Signifies a serious failure that can potentially corrupt application state or require a restart to recover.
    case critical  // Used for extremely severe errors that may cause premature termination and require immediate attention.
    
    public var description: String { rawValue }
    public var echoLevel: Level { self }
    public var filterKey: String? { nil }
}
