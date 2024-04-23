//
//  WindowControlButtonView.swift
//
//
//  Created by Doyoung Song on 4/20/24.
//

import Combine
import UIKit

internal final class WindowControlButtonView: UIView {
    
    private let dotView = UIView()
    private let button = UIButton()
    
    init(color: UIColor) {
        super.init(frame: .zero)
        button.backgroundColor = .clear
        dotView.backgroundColor = color
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dotView.layer.cornerRadius = dotView.frame.height / 2
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
        dotView.backgroundColor = color
    }
}

// MARK: - UI
extension WindowControlButtonView {
    
    private func setupUI() {
        backgroundColor = .clear
        addSubview(button)
        addSubview(dotView)
        button.translatesAutoresizingMaskIntoConstraints = false
        dotView.translatesAutoresizingMaskIntoConstraints = false
        dotView.isUserInteractionEnabled = false
        NSLayoutConstraint.activate([
            dotView.widthAnchor.constraint(equalToConstant: 14),
            dotView.heightAnchor.constraint(equalToConstant: 14),
            dotView.centerXAnchor.constraint(equalTo: centerXAnchor),
            dotView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            button.widthAnchor.constraint(equalTo: widthAnchor),
            button.heightAnchor.constraint(equalTo: heightAnchor),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
