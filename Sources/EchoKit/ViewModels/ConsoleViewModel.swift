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
    
    internal let headerViewModel = HeaderViewModel(.production)
    internal let bodyViewModel = BodyViewModel(.production)
    internal let footerViewModel = FooterViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    internal init() {
        bind()
    }
}

// MARK: - Action
extension ConsoleViewModel {
    
    internal enum Action {
        case activateWindow
        case adjustWindow(WindowControls.Action)
        case quit
        case filter
    }
    
    internal func send(_ action: Action) {
        switch action {
        case .activateWindow:
            windowState = .windowed
        case .adjustWindow(let action):
            controlWindows(action)
        case .quit:
            bodyViewModel.send(.quit)
        case .filter:
            bodyViewModel.send(.toggleFilter)
        }
    }
}

// MARK: - Bindings
extension ConsoleViewModel {
    
    private func bind() {
        bodyViewModel.isQuitable
            .sink { [weak self] in self?.headerViewModel.send(.changeActions(isQuitable: $0)) }
            .store(in: &cancellables)
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
