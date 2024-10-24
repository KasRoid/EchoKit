//
//  BodyViewModel.swift
//  
//
//  Created by Lukas on 4/19/24.
//

import Combine
import Foundation

internal final class BodyViewModel {

    let onScrollToTop = PassthroughSubject<Void, Never>()
    @Published private(set) var logs: [Log] = []
    @Published private(set) var selectedLog: Log?
    @Published private(set) var filter: Filter?
    private(set) var filteredLevels: [Level] = Level.allCases
    private(set) var filteredKeys: [String] = []

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
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                logs = $0.filter { self.filteredLevels.contains($0.level) }
            }
            .store(in: &cancellables)
        
        Buffer.shared.$filterKeys
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.filteredKeys = $0 }
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
        case toggleFilter(Filter?)
        case setLevelFilter([Level])
        case setCustomFilter([String])
        case clearFilters
        case scrollToTop
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
            filter = nil
            selectedLog = nil
            _result.send(.isQuitable(false))
            _result.send(.isFilterable(true))
        case .toggleFilter(let filter):
            self.filter = filter
            _result.send(.isQuitable(filter != nil))
            _result.send(.isFilterable(filter == nil))
        case .setLevelFilter(let filters):
            filteredLevels = filters
            applyFilters()
        case .setCustomFilter(let filters):
            filteredKeys = filters
            applyFilters()
        case .clearFilters:
            filteredLevels = Level.allCases
            filteredKeys = Buffer.shared.filterKeys
            applyFilters()
        case .scrollToTop:
            onScrollToTop.send()
        }
    }
    
    private func applyFilters() {
        logs = Buffer.shared.logs
            .filter {
                if Buffer.shared.filterKeys.isEmpty {
                    filteredLevels.contains($0.level)
                } else {
                    filteredLevels.contains($0.level) && filteredKeys.contains($0.filterKey)
                }
            }
        let isFiltered = !(filteredLevels == Level.allCases && filteredKeys == Buffer.shared.filterKeys)
        _result.send(.isFiltered(isFiltered))
    }
}

// MARK: - Enums
extension BodyViewModel {
    
    internal enum Result {
        case isQuitable(Bool)
        case isFilterable(Bool)
        case isFiltered(Bool)
    }
}
