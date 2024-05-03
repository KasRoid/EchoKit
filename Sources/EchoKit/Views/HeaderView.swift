//
//  HeaderView.swift
//
//
//  Created by Lukas on 4/19/24.
//

import Combine
import UIKit

internal final class HeaderView: UIView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var windowControls: WindowControls!
    @IBOutlet private weak var filterButton: UIButton!
    @IBOutlet private weak var actionButton: UIButton!
    
    private var viewModel: HeaderViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    internal init(viewModel: HeaderViewModel) {
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
        
        filterButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in self?.viewModel.send(.toggleFilter) }
            .store(in: &cancellables)
        
        filterButton.gesturePublisher(.longPress)
            .throttle(for: 0.5, scheduler: DispatchQueue.main, latest: false)
            .sink { [weak self] _ in self?.viewModel.send(.clearFilter) }
            .store(in: &cancellables)
        
        actionButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in self?.viewModel.send(.showActions) }
            .store(in: &cancellables)
        
        viewModel.$isFilterEnabled
            .sink { [weak self] in self?.filterButton.isEnabled = $0 }
            .store(in: &cancellables)
        
        viewModel.$isFilterHighlighted
            .sink { [weak self] in self?.filterButton.tintColor = $0 ? .systemBlue : .white }
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
        
        filterButton.imageView?.contentMode = .scaleAspectFill
        filterButton.imageView?.translatesAutoresizingMaskIntoConstraints = false
        filterButton.imageView?.widthAnchor.constraint(equalToConstant: 18).isActive = true
        filterButton.imageView?.heightAnchor.constraint(equalToConstant: 18).isActive = true
        filterButton.imageView?.centerXAnchor.constraint(equalTo: filterButton.centerXAnchor).isActive = true
        filterButton.imageView?.centerYAnchor.constraint(equalTo: filterButton.centerYAnchor).isActive = true
    }
}
