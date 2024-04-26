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
    
    private let _isQuitable = PassthroughSubject<Bool, Never>()
    internal var isQuitable: AnyPublisher<Bool, Never> { _isQuitable.eraseToAnyPublisher() }
    
    private(set) var pasteboard: Pasteboard
    private var cancellables = Set<AnyCancellable>()
    
    internal init(_ environment: Environment) {
        self.pasteboard = switch environment {
        case .production:
            SystemPasteboard.shared
        case .test:
            MockPasteboard.shared
        }
        bind()
    }
}

// MARK: - Bindings
extension BodyViewModel {
    
    private func bind() {
        Buffer.shared.$logs
            .sink { [weak self] in self?.logs = $0 }
            .store(in: &cancellables)
    }
}

// MARK: - Action
extension BodyViewModel {
    
    internal enum Action {
        case copyLog(Log)
        case copyText(text: String)
        case showDetail(Log)
        case quit
    }
    
    internal func send(_ action: Action) {
        switch action {
        case .copyLog(let log):
            pasteboard.string = "\(log.date.HHmmss) \(log.text)"
        case .copyText(let text):
            pasteboard.string = text
        case .showDetail(let log):
            selectedLog = log
            _isQuitable.send(true)
        case .quit:
            selectedLog = nil
            _isQuitable.send(false)
        }
    }
}
