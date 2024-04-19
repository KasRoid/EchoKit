//
//  HeaderView.swift
//
//
//  Created by Lukas on 4/19/24.
//

import UIKit

internal final class HeaderView: UIView {
    
    private var viewModel: HeaderViewModel!
    
    init(viewModel: HeaderViewModel) {
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
extension HeaderView {
    
    internal func prepare(viewModel: HeaderViewModel) {
        self.viewModel = viewModel
    }
}
