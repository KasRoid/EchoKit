//
//  ActionProvider.swift
//
//
//  Created by Doyoung Song on 4/22/24.
//

import UIKit

protocol ActionProvider {}

extension ActionProvider where Self: UIViewController {
    
    func showActionSheet<T>(title: String? = nil,
                            message: String? = nil,
                            actions: [T],
                            handler: @escaping (T) -> Void,
                            completion: @escaping () -> Void) where T: RawRepresentable<String> {
        let controller = ConsoleAlertController(title: title, message: message, preferredStyle: .actionSheet)
        controller.onDisappear = completion
        for action in actions {
            let alertAction = UIAlertAction(title: action.rawValue, style: .default) { _ in
                handler(action)
            }
            controller.addAction(alertAction)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        controller.addAction(cancel)
        present(controller, animated: true)
    }
    
    func showAlert(title: String? = nil,
                   message: String? = nil,
                   handler: @escaping () -> Void,
                   completion: @escaping () -> Void) {
        let controller = ConsoleAlertController(title: title, message: message, preferredStyle: .alert)
        controller.onDisappear = completion
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        controller.addAction(cancel)
        let clear = UIAlertAction(title: "Clear", style: .destructive, handler: { _ in handler() })
        controller.addAction(clear)
        present(controller, animated: true)
    }
}
