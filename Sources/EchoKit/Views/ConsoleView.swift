//
//  ConsoleView.swift
//
//
//  Created by Lukas on 4/19/24.
//

import UIKit

internal final class ConsoleView: UIView, Echoable {
    
    @IBOutlet private weak var headerView: HeaderView!
    @IBOutlet private weak var bodyView: BodyView!
    @IBOutlet private weak var footerView: FooterView!
    
    init() {
        super.init(frame: .zero)
        setupWithXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupWithXib()
    }
}

// MARK: - Methods
extension ConsoleView {
    
    internal func setupHeaderView(viewModel: HeaderViewModel) {
        headerView.prepare(viewModel: viewModel)
    }

    internal func setupBodyView(viewModel: BodyViewModel) {
        bodyView.prepare(viewModel: viewModel)
    }
    
    internal func setupFooterView(viewModel: FooterViewModel) {
        footerView.prepare(viewModel: viewModel)
    }
}
