//
//  BodyViewModel.swift
//  
//
//  Created by Lukas on 4/19/24.
//

import Combine

internal final class BodyViewModel {
    
    @Published private(set) var logs: [Log] = []
    private var pasteboard: Pasteboard
    private var cancellable: AnyCancellable?
    
    internal init(pasteboard: Pasteboard) {
        self.pasteboard = pasteboard
        bind()
    }
}

// MARK: - Bindings
extension BodyViewModel {
    
    private func bind() {
        cancellable = Buffer.shared.$logs
            .sink { [weak self] in self?.logs = $0 }
    }
}

// MARK: - Action
extension BodyViewModel {
    
    internal enum Action {
        case copy(Log)
    }
    
    internal func send(_ action: Action) {
        switch action {
        case .copy(let log):
            pasteboard.string = "\(log.date.HHmmss) \(log.text)"
        }
    }
}
