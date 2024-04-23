//
//  Buffer.swift
//
//
//  Created by Lukas on 4/19/24.
//

import Combine

internal final class Buffer {
    
    static let shared = Buffer()
    
    @Published private(set) var logs: [Log] = []
}

// MARK: - Methods
extension Buffer {
    
    internal var allTexts: String {
        logs.reduce(into: "") {
            $0 += "\($1.date.HHmmss) \($1.text)"
            guard logs.last != $1 else { return }
            $0 += "\n"
        }
    }
}

// MARK: - Action
extension Buffer {
    
    internal enum Action {
        case append(log: Log)
        case clear
    }
    
    internal func send(_ action: Action) {
        switch action {
        case .append(let log):
            logs.append(log)
        case .clear:
            logs.removeAll()
        }
    }
}
