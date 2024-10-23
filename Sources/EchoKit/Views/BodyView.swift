//
//  BodyView.swift
//
//
//  Created by Lukas on 4/19/24.
//

import Combine
import UIKit

internal final class BodyView: UIView {
    
    @IBOutlet private weak var consoleTableView: ConsoleTableView!
    @IBOutlet private weak var auxiliaryTableView: AuxiliaryTableView!
    
    private var viewModel: BodyViewModel!
    private var consoleDataSource: ConsoleDataSource?
    private var detailDataSource: DetailDataSource?
    private var levelFilterDataSource: FilterDataSource<Level>?
    private var customFilterDataSource: FilterDataSource<String>?
    private var consoleCancellables = Set<AnyCancellable>()
    private var auxiliaryCancellables = Set<AnyCancellable>()
    
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
                guard self?.consoleTableView.isLatestData == true else { return }
                self?.scrollTo(log: $0.last)
            }
            .store(in: &consoleCancellables)
        
        viewModel.$selectedLog
            .sink { [weak self] in
                self?.auxiliaryTableView.isHidden = $0 == nil
                if let log = $0 {
                    self?.setupDetailDataSource(with: log)
                } else {
                    self?.detailDataSource = nil
                }
            }
            .store(in: &consoleCancellables)
        
        viewModel.$filter
            .dropFirst()
            .sink { [weak self] in
                guard let self else { return }
                auxiliaryTableView.isHidden = $0 == nil
                if let filter = $0 {
                    switch filter {
                    case .custom:
                        let filters = Buffer.shared.filterKeys
                        let selected = viewModel.filteredKeys
                        setupCustomFilterDataSource(filters: filters, selected: selected)
                    case .system:
                        let filters = Level.allCases
                        let selected = viewModel.filteredLevels
                        setupLevelFilterDataSource(filters: filters, selected: selected)
                    }
                } else {
                    levelFilterDataSource?.finish()
                    levelFilterDataSource = nil
                    customFilterDataSource?.finish()
                    customFilterDataSource = nil
                }
            }
            .store(in: &consoleCancellables)
        
        consoleTableView.tap
            .sink { [weak self] in self?.viewModel.send(.showDetail($0)) }
            .store(in: &consoleCancellables)
        
        consoleTableView.interaction
            .sink { [weak self] log, interaction in
                switch interaction {
                case .copy:
                    self?.viewModel.send(.copyLog(log))
                }
            }
            .store(in: &consoleCancellables)
    }
}

// MARK: - UI
extension BodyView {
    
    private func setupUI() {
        consoleTableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        auxiliaryTableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        consoleDataSource = .init(tableView: consoleTableView)
    }
    
    private func scrollTo(log: Log?) {
        guard let log, let indexPath = consoleDataSource?.indexPath(for: log) else { return }
        consoleTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
    private func setupDetailDataSource(with log: Log) {
        detailDataSource = .init(tableView: auxiliaryTableView)
        detailDataSource?.update(log: log)
        
        auxiliaryTableView.tap
            .sink { [weak self] in self?.viewModel.send(.quit) }
            .store(in: &auxiliaryCancellables)
        
        auxiliaryTableView.interaction
            .sink { [weak self] text, interaction in
                switch interaction {
                case .copy:
                    self?.viewModel.send(.copyText(text: text))
                }
            }
            .store(in: &auxiliaryCancellables)
    }
    
    private func setupLevelFilterDataSource(filters: [Level], selected: [Level]) {
        levelFilterDataSource = .init(tableView: auxiliaryTableView, filters: filters)
        let prompt = Prompt(title: "Select Level", description: "[Tap to select]")
        levelFilterDataSource?.update(prompt: prompt, selected: selected)
        levelFilterDataSource?.result
            .sink { [weak self] in self?.viewModel.send(.setLevelFilter($0)) }
            .store(in: &auxiliaryCancellables)
    }
    
    private func setupCustomFilterDataSource(filters: [String], selected: [String]) {
        customFilterDataSource = .init(tableView: auxiliaryTableView, filters: filters)
        let prompt = Prompt(title: "Select filter", description: "[Tap to select]")
        customFilterDataSource?.update(prompt: prompt, selected: selected)
        customFilterDataSource?.result
            .sink { [weak self] in self?.viewModel.send(.setCustomFilter($0)) }
            .store(in: &auxiliaryCancellables)
    }
}
