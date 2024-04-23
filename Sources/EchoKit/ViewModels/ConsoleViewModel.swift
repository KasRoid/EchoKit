//
//  ConsoleViewModel.swift
//  
//
//  Created by Lukas on 4/19/24.
//

import Combine

internal final class ConsoleViewModel: Echoable {
    
    @Published private(set) var isActivePublisher: AnyPublisher<Bool, Never>
    @Published private(set) var windowState: WindowState = .windowed
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

// MARK: - Methods
extension ConsoleViewModel {
    
    var fullLogs: String {
        Buffer.shared.fullLogs
    }
}

// MARK: - Action
extension ConsoleViewModel {
    
    internal enum Action {
        case activateWindow
        case adjustWindow(WindowControls.Action)
        case divider
        case clear
        case copy
    }
    
    internal func send(_ action: Action) {
        switch action {
        case .activateWindow:
            windowState = .windowed
        case .adjustWindow(let action):
            controlWindows(action)
        case .divider:
            let log = Log(text: "==========", level: .info)
            Buffer.shared.send(.append(log: log))
        case .clear:
            Buffer.shared.send(.clear)
        case .copy:
            pasteboard.string = fullLogs
        }
    }
}

// MARK: - Private Functions
extension ConsoleViewModel {
    
    private func controlWindows(_ actions: WindowControls.Action) {
        switch actions {
        case .close:
            windowState = .closed
        case .minimize:
            windowState = .minimized
        case .fullscreen:
            windowState = windowState == .windowed ? .fullscreen : .windowed
        }
    }
}

// MARK: - Enums
extension ConsoleViewModel {
    
    internal enum Environment {
        case production
        case test
    }
    
    internal enum WindowState {
        case fullscreen
        case minimized
        case windowed
        case closed
    }
}
