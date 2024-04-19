//
//  File.swift
//  
//
//  Created by Lukas on 4/19/24.
//

import Combine

final class Buffer {
    
    static let shared = Buffer()
    private(set) var logs: [Log] = []
    private init() {}
}

// MARK: - Methods
extension Buffer {
    
    enum Action {
        case append(log: Log)
    }
    
    func send(_ action: Action) {
        switch action {
        case .append(let log):
            logs.append(log)
        }
    }
}
