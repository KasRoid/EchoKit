//
//  BodyView.swift
//
//
//  Created by Lukas on 4/19/24.
//

import Combine
import UIKit

internal final class BodyView: UIView {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var viewModel: BodyViewModel!
    private var dataSource: ConsoleDataSource?
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: BodyViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupWithXib()
        setupUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupWithXib()
    }
}

// MARK: - Methods
extension BodyView {
    
    internal func prepare(viewModel: BodyViewModel) {
        self.viewModel = viewModel
        setupUI()
        bind()
    }
}

// MARK: - Bindings
extension BodyView {
    
    private func bind() {
        viewModel.$logs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.dataSource?.update(logs: $0)
                self?.scrollTo(log: $0.last)
            }
            .store(in: &cancellables)
    }
}

// MARK: - UI
extension BodyView {
    
    private func setupUI() {
        tableView.rowHeight = 14
        tableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        dataSource = .init(logs: viewModel.logs, tableView: tableView)
    }
    
    private func scrollTo(log: Log?) {
        guard let log, let indexPath = dataSource?.indexPath(for: log) else { return }
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
}
