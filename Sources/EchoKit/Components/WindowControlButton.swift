//
//  WindowControlButtonView.swift
//
//
//  Created by Doyoung Song on 4/20/24.
//

import Combine
import UIKit

internal final class WindowControlButtonView: UIView {
    
    private let button = UIButton()
    
    init(color: UIColor) {
        super.init(frame: .zero)
        button.backgroundColor = color
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.layer.cornerRadius = button.frame.height / 2
    }
}

// MARK: - Methods
extension WindowControlButtonView {
    
    internal var tap: AnyPublisher<Void, Never> {
        button.publisher(for: .touchUpInside)
            .map { _ in Void() }
            .eraseToAnyPublisher()
    }
    
    internal func prepare(color: UIColor) {
        button.backgroundColor = color
    }
}

// MARK: - UI
extension WindowControlButtonView {
    
    private func setupUI() {
        backgroundColor = .clear
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 14),
            button.heightAnchor.constraint(equalToConstant: 14),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
