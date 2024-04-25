//
//  HeaderViewModel.swift
//
//
//  Created by Lukas on 4/19/24.
//

import Combine
import UIKit

internal final class HeaderViewModel {
    
    private let subject = PassthroughSubject<Action, Never>()
    internal var publisher: AnyPublisher<Action, Never> { subject.eraseToAnyPublisher() }
    
    private(set) var moreActions: [MoreAction] = [.systemInfo, .buidInfo, .share, .divider, .copy, .clear]
    private let isQuitablePublisher: AnyPublisher<Bool, Never>
    private var cancellable: AnyCancellable?
    
    internal init(isQuitablePublisher: AnyPublisher<Bool, Never>) {
        self.isQuitablePublisher = isQuitablePublisher
        bind()
    }
}

// MARK: - Action
extension HeaderViewModel {
    
    internal enum Action: Equatable {
        case adjustWindow(WindowControls.Action)
        case showActions
    }
    
    internal func send(_ action: Action) {
        subject.send(action)
    }
}

// MARK: - Bindings
extension HeaderViewModel {
    
    private func bind() {
        cancellable = isQuitablePublisher
            .sink { [weak self] in
                self?.moreActions = $0
                ? [.quit]
                : [.systemInfo, .buidInfo, .share, .divider, .copy, .clear]
            }
    }
}

// MARK: - Enums
extension HeaderViewModel {
    
    internal enum MoreAction: String, CaseIterable {
        case systemInfo = "System Info"
        case buidInfo = "Build Info"
        case share = "Share"
        case divider = "Divider"
        case copy = "Copy"
        case clear = "Clear"
        case quit = "Quit"
    }
}
