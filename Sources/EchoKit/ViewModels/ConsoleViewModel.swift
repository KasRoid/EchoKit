//
//  ConsoleViewModel.swift
//
//
//  Created by Lukas on 4/19/24.
//

import Combine
import UIKit

internal final class ConsoleViewModel: Echoable {
    
    @Published private(set) var windowState: WindowState = .windowed
    
    private(set) var pasteboard: Pasteboard
    
    internal init(_ environment: Environment) {
        pasteboard = switch environment {
        case .production:
            SystemPasteboard.shared
        case .test:
            MockPasteboard.shared
        }
    }
}

// MARK: - Methods
extension ConsoleViewModel {
    
    internal var fullLogs: String {
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
        case showBuildInfo
        case showSystemInfo
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
        case .showBuildInfo:
            Console.echo(Project.info)
        case .showSystemInfo:
            Console.echo(System.info)
        }
    }
}

// MARK: - Private Functions
extension ConsoleViewModel {
    
    private func controlWindows(_ actions: WindowControls.Action) {
        switch actions {
        case .close:
            guard windowState != .closed else { return }
            windowState = .closed
        case .minimize:
            guard windowState != .minimized else { return }
            windowState = .minimized
        case .zoom:
            windowState = windowState == .windowed ? .fullscreen : .windowed
        }
    }
}

// MARK: - Enums
extension ConsoleViewModel {
    
    internal enum WindowState {
        case fullscreen
        case minimized
        case windowed
        case closed
    }
}
