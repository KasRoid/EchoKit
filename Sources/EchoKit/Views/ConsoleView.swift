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
    
    private var viewModel: ConsoleViewModel?
    
    init(viewModel: ConsoleViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupWithXib()
        setupSubViewModels()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupWithXib()
    }
}

// MARK: - Methods
extension ConsoleView {
    
    internal func prepare(viewModel: ConsoleViewModel) {
        self.viewModel = viewModel
        setupSubViewModels()
    }
    
    internal func setupSubViewModels() {
        headerView.prepare(viewModel: HeaderViewModel())
        bodyView.prepare(viewModel: BodyViewModel())
        footerView.prepare(viewModel: FooterViewModel())
    }
}
