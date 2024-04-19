//
//  ConsoleView.swift
//
//
//  Created by Lukas on 4/19/24.
//

import UIKit

internal final class ConsoleView: UIView, Echoable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupWithXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupWithXib()
    }
}
