//
//  ConsoleWindow.swift
//
//
//  Created by Lukas on 4/22/24.
//

import Combine
import UIKit

internal final class ConsoleWindow: UIWindow {
    
    private let interactiveView = UIView()
    
    init(windowScene: UIWindowScene, publisher: AnyPublisher<Bool, Never>) {
        super.init(windowScene: windowScene)
        let viewModel = ConsoleViewModel(.production, publisher: publisher)
        self.rootViewController = ConsoleViewController(viewModel: viewModel, interactiveView: interactiveView)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        interactiveView.frame.contains(point) ? super.hitTest(point, with: event) : nil
    }
}

// MARK: - UI
extension ConsoleWindow {
    
    private func setupUI() {
        backgroundColor = .clear
        windowLevel = .alert + 1
    }
}
