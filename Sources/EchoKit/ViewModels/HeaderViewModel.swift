//
//  HeaderViewModel.swift
//
//
//  Created by Lukas on 4/19/24.
//

import Combine
import UIKit

internal final class HeaderViewModel {
    
    private let _result = PassthroughSubject<Result, Never>()
    internal var result: AnyPublisher<Result, Never> { _result.eraseToAnyPublisher() }
    
    @Published internal var isFilterEnabled = true
    
    private(set) var moreActions = MoreAction.defaultActions
    private var pasteboard: Pasteboard
    private var cancellable: AnyCancellable?
    
    internal init(_ environment: Environment) {
        pasteboard = switch environment {
        case .production:
            SystemPasteboard.shared
        case .test:
            MockPasteboard.shared
        }
    }
}

// MARK: - Action
extension HeaderViewModel {
    
    internal enum Action: Equatable {
        case adjustWindow(WindowControls.Action)
        case showActions
        case changeActions(isQuitable: Bool)
        case toggleFilter
        case enableFilter(isEnabled: Bool)
    }
    
    internal func send(_ action: Action) {
        switch action {
        case .adjustWindow(let windowAction):
            _result.send(.window(action: windowAction))
        case .showActions:
            _result.send(.actions(actions: moreActions, handler: handleAction))
        case .changeActions(let isQuitable):
            moreActions = isQuitable ? MoreAction.quitabletActions : MoreAction.defaultActions
        case .toggleFilter:
            let showOption = !Buffer.shared.filterKeys.isEmpty
            _result.send(.filter(showOption: showOption))
        case .enableFilter(let isEnabled):
            isFilterEnabled = isEnabled
        }
    }
}

// MARK: - Result
extension HeaderViewModel {
    
    internal enum Result {
        case actions(actions: [MoreAction], handler: (MoreAction) -> Void)
        case window(action: WindowControls.Action)
        case quit
        case filter(showOption: Bool)
    }
    
    private func handleAction(_ action: MoreAction) {
        switch action {
        case .buidInfo:
            Console.echo(Project.info)
        case .systemInfo:
            Console.echo(System.info)
        case .divider:
            let log = Log(text: "==========", level: Level.info)
            Buffer.shared.send(.append(log: log))
        case .clear:
            Buffer.shared.send(.clear)
        case .copy:
            pasteboard.string = Buffer.shared.fullLogs
        case .quit:
            _result.send(.quit)
        }
    }
}

// MARK: - Enums
extension HeaderViewModel {
    
    internal enum MoreAction: String, CaseIterable {
        case systemInfo = "System Info"
        case buidInfo = "Build Info"
        case divider = "Divider"
        case copy = "Copy"
        case clear = "Clear"
        case quit = "Quit"
        
        static let defaultActions: [MoreAction] = [.systemInfo, .buidInfo, .divider, .copy, .clear]
        static let quitabletActions: [MoreAction] = [.quit]
    }
}
