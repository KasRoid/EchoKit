//
//  HeaderView.swift
//
//
//  Created by Lukas on 4/19/24.
//

import Combine
import UIKit

internal final class HeaderView: UIView, Echoable {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var windowControls: WindowControls!
    @IBOutlet private weak var actionButton: UIButton!
    
    private var viewModel: HeaderViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: HeaderViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupWithXib()
        setupUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupWithXib()
        setupUI()
    }
}

// MARK: - Methods
extension HeaderView {
    
    internal func prepare(viewModel: HeaderViewModel) {
        self.viewModel = viewModel
        bind()
    }
}

// MARK: - Bindings
extension HeaderView {
    
    internal func bind() {
        windowControls.tap
            .sink { [weak self] in self?.viewModel.send(.adjustWindow($0)) }
            .store(in: &cancellables)
        
        actionButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in self?.viewModel.send(.showActions) }
            .store(in: &cancellables)
    }
}

// MARK: - UI
extension HeaderView {
    
    private func setupUI() {
        actionButton.imageView?.contentMode = .scaleAspectFill
        actionButton.imageView?.translatesAutoresizingMaskIntoConstraints = false
        actionButton.imageView?.widthAnchor.constraint(equalToConstant: 18).isActive = true
        actionButton.imageView?.heightAnchor.constraint(equalToConstant: 18).isActive = true
        actionButton.imageView?.centerXAnchor.constraint(equalTo: actionButton.centerXAnchor).isActive = true
        actionButton.imageView?.centerYAnchor.constraint(equalTo: actionButton.centerYAnchor).isActive = true
    }
}
