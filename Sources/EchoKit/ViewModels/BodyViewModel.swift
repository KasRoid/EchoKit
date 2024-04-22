//
//  BodyViewModel.swift
//  
//
//  Created by Lukas on 4/19/24.
//

import Combine

internal final class BodyViewModel {
    
    @Published private(set) var logs: [Log] = []
    private var cancellable: AnyCancellable?
    
    init() {
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
