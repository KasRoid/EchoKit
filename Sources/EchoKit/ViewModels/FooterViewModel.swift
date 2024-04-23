//
//  FooterViewModel.swift
//  
//
//  Created by Lukas on 4/19/24.
//

import Combine

internal final class FooterViewModel {
    
    @Published private(set) var count = 0
    private var cancellable: AnyCancellable?
    
    init() {
        bind()
    }
}

// MARK: - Bindings
extension FooterViewModel {
    
    private func bind() {
        cancellable = Buffer.shared.$logs
            .sink { [weak self] in self?.count = $0.count }
    }
}
