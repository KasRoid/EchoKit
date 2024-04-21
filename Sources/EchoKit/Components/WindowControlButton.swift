//
//  WindowControlButton.swift
//
//
//  Created by Doyoung Song on 4/20/24.
//

import UIKit

internal final class WindowControlButton: UIButton {
    
    init(color: UIColor) {
        super.init(frame: .zero)
        backgroundColor = color
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
}

// MARK: - Methods
extension WindowControlButton {
    
    internal func prepare(color: UIColor) {
        backgroundColor = color
    }
}

// MARK: - UI
extension WindowControlButton {
    
    private func setupUI() {
        layer.cornerRadius = frame.size.height / 2
        clipsToBounds = true
    }
}
