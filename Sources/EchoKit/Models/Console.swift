//
//  Console.swift
//
//
//  Created by Lukas on 4/19/24.
//

public struct Console {
    
    internal static let buffer = Buffer.shared
    
    private init() {}
}

// MARK: - Public Methods
extension Console {

    public static func start() {}
    
    public static func echo(_ text: String, level: Level = .debug) {
        let log = Log(text: text, level: level)
        buffer.send(.append(log: log))
    }
}

// MARK: - Methods
extension Console {
    
    internal static func addDivider() {
        let log = Log(text: "==========", level: .info)
        buffer.send(.append(log: log))
    }
}
