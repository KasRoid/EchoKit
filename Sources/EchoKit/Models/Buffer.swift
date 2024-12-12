//
//  Buffer.swift
//
//
//  Created by Lukas on 4/19/24.
//

import Combine
import Foundation

internal final class Buffer {
    
    static let shared = Buffer()
    
    @Published private(set) var logs: [Log] = []
    @Published private(set) var filterKeys: [String] = []
    private let maxLogs = 5000
    private let syncQueue = DispatchQueue(label: "Buffer.syncQueue", attributes: .concurrent)
    
    private init() {}
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
            syncQueue.async(flags: .barrier) { [weak self] in
                guard let self else { return }
                if logs.count >= maxLogs {
                    logs.removeFirst()
                }
                logs.append(log)
            }
        case .setFilterKeys(let filterKeys):
            self.filterKeys = filterKeys
        case .clear:
            syncQueue.async(flags: .barrier) { [weak self] in
                guard let self else { return }
                logs.removeAll()
            }
        }
    }
}
