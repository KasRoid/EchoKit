//
//  BodyViewModel.swift
//  
//
//  Created by Lukas on 4/19/24.
//

import Combine

internal final class BodyViewModel {
    
    @Published private(set) var logs: [Log] = []
    @Published private(set) var selectedLog: Log?
    private(set) var pasteboard: Pasteboard
    private let quitPublisher: AnyPublisher<Void, Never>
    private var cancellables = Set<AnyCancellable>()
    
    internal init(environment: Environment, quitPublisher: AnyPublisher<Void, Never>) {
        self.pasteboard = switch environment {
        case .production:
            SystemPasteboard.shared
        case .test:
            MockPasteboard.shared
        }
        self.quitPublisher = quitPublisher
        bind()
    }
}

// MARK: - Methods
extension BodyViewModel {
    
    internal var logSelected: AnyPublisher<Void, Never> {
        $selectedLog
            .dropFirst()
            .filter { $0 != nil }
            .map { _ in Void() }
            .eraseToAnyPublisher()
    }
}

// MARK: - Bindings
extension BodyViewModel {
    
    private func bind() {
        Buffer.shared.$logs
            .sink { [weak self] in self?.logs = $0 }
            .store(in: &cancellables)
        
        quitPublisher
            .sink { [weak self] in self?.selectedLog = nil }
            .store(in: &cancellables)
    }
}

// MARK: - Action
extension BodyViewModel {
    
    internal enum Action {
        case copy(Log)
        case showDetail(Log)
    }
    
    internal func send(_ action: Action) {
        switch action {
        case .copy(let log):
            pasteboard.string = "\(log.date.HHmmss) \(log.text)"
        case .showDetail(let log):
            selectedLog = log
        }
    }
}
