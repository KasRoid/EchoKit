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
        button.setImage(dotView.asImage, for: .normal)
    }
}

// MARK: - UI
extension WindowControlButtonView {
    
    private func setupUI() {
        backgroundColor = .clear
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalTo: widthAnchor),
            button.heightAnchor.constraint(equalTo: heightAnchor),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        button.imageView?.widthAnchor.constraint(equalToConstant: 14).isActive = true
        button.imageView?.heightAnchor.constraint(equalToConstant: 14).isActive = true
        button.imageView?.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        button.imageView?.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        
        dotView.frame.size = CGSize(width: 14, height: 14)
        dotView.layer.cornerRadius = 7
    }
}
