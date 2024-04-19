//
//  Buffer.swift
//
//
//  Created by Lukas on 4/19/24.
//

import Combine

internal final class Buffer {
    
    static let shared = Buffer(.production)
    static let mock = Buffer(.test)
    
    @Published private(set) var logs: [Log] = []
    private(set) var pasteboard: Pasteboard
    
    private init(_ environment: Environment) {
        pasteboard = switch environment {
        case .production:
            SystemPasteboard.shared
        case .test:
            MockPasteboard.shared
        }
    }
}

// MARK: - Methods
extension Buffer {
    
    enum Action {
        case append(log: Log)
        case clear
        case copy(text: String)
    }
    
    func send(_ action: Action) {
        switch action {
        case .append(let log):
            logs.append(log)
        case .clear:
            logs.removeAll()
        case .copy(let text):
            pasteboard.string = text
        }
    }
}

// MARK: - Enums
extension Buffer {
    
    enum Environment {
        case production
        case test
    }
}
