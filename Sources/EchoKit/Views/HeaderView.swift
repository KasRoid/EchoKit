//
//  HeaderView.swift
//
//
//  Created by Lukas on 4/19/24.
//

import Combine
import UIKit

internal final class HeaderView: UIView {
    
    @IBOutlet private weak var windowControls: WindowControls!
    
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
        bind()
    }
}

// MARK: - Methods
extension HeaderView {
    
    internal func prepare(viewModel: HeaderViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - Bindings
extension HeaderView {
    
    internal func bind() {
        windowControls.tap
            .sink { print($0) }
            .store(in: &cancellables)
    }
}
