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
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupWithXib()
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
            .sink { [weak self] in self?.print($0) }
            .store(in: &cancellables)
        
        actionButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in self?.viewModel.send(.showActions) }
            .store(in: &cancellables)
    }
}
