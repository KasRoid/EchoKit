//
//  MainViewController.swift
//  EchoKit-Demo
//
//  Created by Lukas on 4/19/24.
//

import Combine
import EchoKit
import UIKit

final class MainViewController: UIViewController, Echoable, AlertProvider {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var dataSource: MainDataSource?
    private var viewModel: MainViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Console.echo("Welcome to EchoKit Demo!", level: .notice)
        let repository = MainRepositoryModel()
        viewModel = MainViewModel(repository: repository)
        measure()
        bind()
    }
}

// MARK: - Bindings
extension MainViewController {
    
    private func bind() {
        dataSource?.result
            .sink { [weak self] in self?.handleDataSourceResult($0) }
            .store(in: &cancellables)
        
        viewModel?.$isMeasuring
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.dataSource?.updateMeasureState(isMeasuring: $0) }
            .store(in: &cancellables)
    }
}

// MARK: - UI
extension MainViewController {
    
    private func measure() {
        Console.measure(task: "TableView Setup") { [weak self] done in
            self?.setupUI()
            done()
        }
    }
    
    private func setupUI() {
        dataSource = .init(tableView: tableView)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 12))
    }
    
    private func handleDataSourceResult(_ tutorial: Tutorial) {
        switch tutorial {
        case .about, .level, .measure, .api:
            viewModel?.send(.tutorial(tutorial))
        case .input:
            showInputAlert(title: "Input", message: "Type any text") { text in
                guard let text else { return }
                Console.echo(text, level: .trace)
            }
        }
    }
}
