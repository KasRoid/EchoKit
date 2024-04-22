//
//  ConsoleWindow.swift
//
//
//  Created by Lukas on 4/22/24.
//

import UIKit

internal final class ConsoleWindow: UIWindow {
    
    private let interactiveView = UIView()
    
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        interactiveView.frame.contains(point) ? super.hitTest(point, with: event) : nil
    }
    
    override func addSubview(_ view: UIView) {
        interactiveView.addSubview(view)
        view.frame = interactiveView.bounds
    }
}

// MARK: - UI
extension ConsoleWindow {
    
    private func setupUI() {
        backgroundColor = .clear
        windowLevel = .alert + 1
        setupInteractionView()
    }
    
    private func setupInteractionView() {
        interactiveView.width = UIView.screenWidth
        interactiveView.height = UIView.screenHeight / 3
        interactiveView.backgroundColor = .red
        interactiveView.frame.origin = .init(x: 0, y: UIView.screenHeight - interactiveView.height)
        super.addSubview(interactiveView)
    }
}
