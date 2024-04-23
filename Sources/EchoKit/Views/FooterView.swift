//
//  FooterView.swift
//
//
//  Created by Lukas on 4/19/24.
//

import Combine
import UIKit

internal final class FooterView: UIView {
    
    @IBOutlet private weak var cpuLabel: UILabel!
    @IBOutlet private weak var memoryLabel: UILabel!
    @IBOutlet private weak var logCountLabel: UILabel!
    
    private var viewModel: FooterViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    internal init(viewModel: FooterViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupWithXib()
        bind()
    }
    
    internal required init?(coder: NSCoder) {
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
        viewModel.cpuUsage
            .map { String(format: "CPU: %1.0f", $0) + "%," }
            .sink { [weak self] in self?.cpuLabel.text = $0 }
            .store(in: &cancellables)
        
        viewModel.memoryUsage
            .map { String(format: "Mem: %.2fGB / %.2fGB", $0.used, $0.total) }
            .sink { [weak self] in self?.memoryLabel.text = $0 }
            .store(in: &cancellables)
        
        viewModel.logCount
            .sink { [weak self] in self?.logCountLabel.text = "\($0)L" }
            .store(in: &cancellables)
    }
}
