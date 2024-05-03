//
//  MainViewController.swift
//  EchoKit-Demo
//
//  Created by Lukas on 4/19/24.
//

import Combine
import EchoKit
import UIKit

final class MainViewController: UIViewController, Echoable {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var dataSource: MainDataSource?
    private var viewModel = MainViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Console.echo("Welcome to EchoKit Demo!", level: .notice)
        measure()
        bind()
    }
}

// MARK: - Bindings
extension MainViewController {
    
    private func bind() {
        dataSource?.result
            .sink { [weak self] in self?.viewModel.send(.tutorial($0)) }
            .store(in: &cancellables)
    }
}

// MARK: - UI
extension MainViewController {
    
    private func measure() {
        Console.measure(message: "TableView setup took") { [weak self] done in
            self?.setupUI()
            done()
        }
    }
    
    private func setupUI() {
        dataSource = .init(tableView: tableView)
    }
}
