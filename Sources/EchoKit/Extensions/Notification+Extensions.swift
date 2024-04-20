//
//  Notification.swift
//
//
//  Created by Doyoung Song on 4/19/24.
//

import Combine
import Foundation

internal extension Notification.Name {
    static let consoleDidToggle = Notification.Name(rawValue: "consoleDidToggle")
}

internal extension Notification {
    
    static var consoleDidTogglePublisher: AnyPublisher<Bool, Never> {
        NotificationCenter.default.publisher(for: .consoleDidToggle)
            .compactMap { $0.object as? Bool }
            .eraseToAnyPublisher()
    }
    
    static func sendConsoleToggle(isOn: Bool) {
        NotificationCenter.default.post(name: .consoleDidToggle, object: isOn)
    }
}
