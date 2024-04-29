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
    @Published private(set) var isFilterable = false
    private(set) var filteredLevels: [Level] = Level.allCases
    
    private let _result = PassthroughSubject<Result, Never>()
    internal var result: AnyPublisher<Result, Never> { _result.eraseToAnyPublisher() }

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
        case toggleFilter
        case setLevelFilter([Level])
    }
    
    internal func send(_ action: Action) {
        switch action {
        case .copyLog(let log):
            pasteboard.string = "\(log.date.HHmmss) \(log.text)"
        case .copyText(let text):
            pasteboard.string = text
        case .showDetail(let log):
            selectedLog = log
            _result.send(.isQuitable(true))
            _result.send(.isFilterable(false))
        case .quit:
            isFilterable = false
            selectedLog = nil
            _result.send(.isQuitable(false))
            _result.send(.isFilterable(true))
        case .toggleFilter:
            isFilterable.toggle()
        case .setLevelFilter(let filters):
            filteredLevels = filters
        }
    }
}

// MARK: - Enums
extension BodyViewModel {
    
    internal enum Result {
        case isQuitable(Bool)
        case isFilterable(Bool)
    }
}
