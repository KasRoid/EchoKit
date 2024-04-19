//
//  FooterView.swift
//
//
//  Created by Lukas on 4/19/24.
//

import UIKit

internal final class FooterView: UIView {
    
    private var viewModel: FooterViewModel!
    
    init(viewModel: FooterViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupWithXib()
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
    }
}
