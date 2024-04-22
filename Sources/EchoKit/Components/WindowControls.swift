//
//  WindowControls.swift
//
//
//  Created by Lukas on 4/22/24.
//

import Combine
import UIKit

internal final class WindowControls: UIView {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var closeButtonView: WindowControlButtonView!
    @IBOutlet private weak var minimizeButtonView: WindowControlButtonView!
    @IBOutlet private weak var fullscreenButtonView: WindowControlButtonView!
    
    private var subject = PassthroughSubject<Action, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupWithXib()
        setupUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupWithXib()
        setupUI()
        bind()
    }
}

// MARK: - Methods
extension WindowControls {
    
    internal var tap: AnyPublisher<Action, Never> {
        subject.eraseToAnyPublisher()
    }
}

// MARK: - Enums
extension WindowControls {
    
    internal enum Action {
        case close
        case minimize
        case fullscreen
    }
}

// MARK: - Bindings
extension WindowControls {
    
    func bind() {
        closeButtonView.tap
            .sink { [weak self] in self?.subject.send(.close) }
            .store(in: &cancellables)
        
        minimizeButtonView.tap
            .sink { [weak self] in self?.subject.send(.minimize) }
            .store(in: &cancellables)
        
        fullscreenButtonView.tap
            .sink { [weak self] in self?.subject.send(.fullscreen) }
            .store(in: &cancellables)
    }
}

// MARK: - UI
extension WindowControls {
    
    private func setupUI() {
        closeButtonView.prepare(color: .red)
        minimizeButtonView.prepare(color: .yellow)
        fullscreenButtonView.prepare(color: .green)
    }
}
