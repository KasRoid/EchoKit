//
//  BodyView.swift
//
//
//  Created by Lukas on 4/19/24.
//

import Combine
import UIKit

internal final class BodyView: UIView {
    
    @IBOutlet private weak var consoleTableView: UITableView!
    @IBOutlet private weak var detailTableView: UITableView!
    
    private var viewModel: BodyViewModel!
    private var consoleDataSource: ConsoleDataSource?
    private var detailDataSource: DetailDataSource?
    private var cancellables = Set<AnyCancellable>()
    
    internal init(viewModel: BodyViewModel) {
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
            .throttle(for: 0.1, scheduler: DispatchQueue.main, latest: true)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.consoleDataSource?.update(logs: $0)
                self?.scrollTo(log: $0.last)
            }
            .store(in: &cancellables)
        
        viewModel.$selectedLog
            .sink { [weak self] in
                self?.detailTableView.isHidden = $0 == nil
                if let log = $0 {
                    self?.setupDetailDataSource(with: log)
                } else {
                    self?.detailDataSource = nil
                }
            }
            .store(in: &cancellables)
        
        consoleDataSource?.tap
            .sink { [weak self] in self?.viewModel.send(.showDetail($0)) }
            .store(in: &cancellables)
        
        consoleDataSource?.interaction
            .sink { [weak self] log, interaction in
                switch interaction {
                case .copy:
                    self?.viewModel.send(.copy(log))
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - UI
extension BodyView {
    
    private func setupUI() {
        consoleTableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        consoleDataSource = .init(tableView: consoleTableView)
    }
    
    private func scrollTo(log: Log?) {
        guard let log, let indexPath = consoleDataSource?.indexPath(for: log) else { return }
        consoleTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
    private func setupDetailDataSource(with log: Log) {
        detailDataSource = .init(tableView: detailTableView)
        detailDataSource?.update(log: log)
    }
}
