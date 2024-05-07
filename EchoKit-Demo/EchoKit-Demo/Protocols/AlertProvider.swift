//
//  AlertProvider.swift
//  EchoKit-Demo
//
//  Created by Lukas on 5/7/24.
//

import UIKit

protocol AlertProvider where Self: UIViewController {}

extension AlertProvider {
    
    func showInputAlert(title: String?, message: String?, handler: @escaping (String?) -> Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField()
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let confirm = UIAlertAction(title: "Confirm", style: .default) { _ in
            handler(alertController.textFields?.first?.text)
        }
        alertController.addAction(cancel)
        alertController.addAction(confirm)
        present(alertController, animated: true)
    }
}
