//
//  Console.swift
//
//
//  Created by Lukas on 4/19/24.
//

import Foundation

public struct Console {
    
    private init() {}
    
    public static func start() {}
    
    public static func echo(_ text: String, level: Level = .debug) {
        let log = Log(text: text, level: level)
        Buffer.shared.send(.append(log: log))
    }
    
    static func addDivider() {
        let log = Log(text: "==========", level: .info)
        Buffer.shared.send(.append(log: log))
    }
}
