//
//  ActionProvider.swift
//
//
//  Created by Doyoung Song on 4/22/24.
//

import UIKit

protocol ActionProvider {}

extension ActionProvider where Self: UIViewController {
    
    func showActionSheet<T>(title: String? = nil, messamge: String? = nil, actions: [T], handler: @escaping (T) -> Void) where T: RawRepresentable<String> {
        let controller = UIAlertController(title: title, message: messamge, preferredStyle: .actionSheet)
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
}
