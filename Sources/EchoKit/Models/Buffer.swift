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
    @Published private(set) var filterKeys: [String] = []
    private let maxLogs = 5000
}

// MARK: - Methods
extension Buffer {
    
    internal var fullLogs: String {
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
        case setFilterKeys([String])
        case clear
    }
    
    internal func send(_ action: Action) {
        switch action {
        case .append(let log):
            if logs.count >= maxLogs {
                logs.removeFirst()
            }
            logs.append(log)
        case .setFilterKeys(let filterKeys):
            self.filterKeys = filterKeys
        case .clear:
            logs.removeAll()
        }
    }
}
