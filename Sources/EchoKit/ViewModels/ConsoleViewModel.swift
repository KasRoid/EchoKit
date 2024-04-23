//
//  ConsoleViewModel.swift
//  
//
//  Created by Lukas on 4/19/24.
//

import Combine

internal final class ConsoleViewModel {
    
    @Published private(set) var isActivePublisher: AnyPublisher<Bool, Never>
    
    init(publisher: AnyPublisher<Bool, Never>) {
        isActivePublisher = publisher
    }
}

// MARK: - Action
extension ConsoleViewModel {
    
    enum Action {
        case clear
        case copy
    }
    
    func send(_ action: Action) {
        switch action {
        case .clear:
            Buffer.shared.send(.clear)
        case .copy:
            print("Copy")
        }
    }
}
