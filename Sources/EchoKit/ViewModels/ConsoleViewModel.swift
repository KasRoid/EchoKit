//
//  ConsoleViewModel.swift
//  
//
//  Created by Lukas on 4/19/24.
//

import Combine

internal final class ConsoleViewModel: Echoable {
    
    @Published private(set) var isActivePublisher: AnyPublisher<Bool, Never>
    private(set) var pasteboard: Pasteboard
    
    internal init(_ environment: Environment, publisher: AnyPublisher<Bool, Never>) {
        pasteboard = switch environment {
        case .production:
            SystemPasteboard.shared
        case .test:
            MockPasteboard.shared
        }
        isActivePublisher = publisher
    }
}

// MARK: - Action
extension ConsoleViewModel {
    
    internal enum Action {
        case clear
        case copy
    }
    
    internal func send(_ action: Action) {
        switch action {
        case .clear:
            Buffer.shared.send(.clear)
        case .copy:
            pasteboard.string = Buffer.shared.allTexts
        }
    }
}

// MARK: - Enums
extension ConsoleViewModel {
    
    internal enum Environment {
        case production
        case test
    }
}
