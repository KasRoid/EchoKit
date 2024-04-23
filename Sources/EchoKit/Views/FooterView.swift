//
//  FooterView.swift
//
//
//  Created by Lukas on 4/19/24.
//

import Combine
import UIKit

internal final class FooterView: UIView {
    
    @IBOutlet private weak var logCountLabel: UILabel!
    private var viewModel: FooterViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: FooterViewModel) {
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
extension FooterView {
    
    internal func prepare(viewModel: FooterViewModel) {
        self.viewModel = viewModel
        bind()
    }
}

// MARK: - Bindings
extension FooterView {
    
    private func bind() {
        viewModel.$count
            .sink { [weak self] in self?.logCountLabel.text = "\($0)L" }
            .store(in: &cancellables)
    }
}
