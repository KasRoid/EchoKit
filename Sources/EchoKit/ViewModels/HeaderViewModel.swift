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
    var publisher: AnyPublisher<Action, Never> { subject.eraseToAnyPublisher() }
    
    let moreActions = MoreAction.allCases
}

// MARK: - Action
extension HeaderViewModel {
    
    enum Action {
        case showActions
    }
    
    func send(_ action: Action) {
        subject.send(action)
    }
}

// MARK: - Enums
extension HeaderViewModel {
    
    enum MoreAction: String, CaseIterable {
        case divider = "Divider"
        case copy = "Copy"
        case clear = "Clear"
    }
}
