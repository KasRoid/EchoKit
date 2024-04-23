//
//  ConsoleAlertController.swift
//  
//
//  Created by Lukas on 4/23/24.
//

import UIKit

internal final class ConsoleAlertController: UIAlertController {
    
    internal var onDisappear: (() -> Void)?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        onDisappear?()
    }
}
