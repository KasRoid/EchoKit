//
//  File.swift
//  
//
//  Created by Lukas on 4/19/24.
//

import Combine

internal final class ConsoleViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        bind()
    }
}

// MARK: - Bindings
extension ConsoleViewModel {
    
    private func bind() {
        Buffer.shared.$logs
            .sink { print("New log: ", $0) }
            .store(in: &cancellables)
    }
}
