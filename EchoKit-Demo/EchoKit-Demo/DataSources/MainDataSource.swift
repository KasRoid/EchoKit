//
//  MainDataSource.swift
//  EchoKit-Demo
//
//  Created by Lukas on 5/3/24.
//

import Combine
import EchoKit
import UIKit

final class MainDataSource: UITableViewDiffableDataSource<AnyHashable, Tutorial>, Echoable {
    
    private let _result = PassthroughSubject<(Tutorial), Never>()
    var result: AnyPublisher<(Tutorial), Never> { _result.eraseToAnyPublisher() }
    
    private weak var tableView: UITableView?
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = itemIdentifier.rawValue
            cell.selectionStyle = .none
            cell.backgroundColor = .systemGray6
            return cell
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        update()
    }
    
    private func update() {
        var snapshot = NSDiffableDataSourceSnapshot<AnyHashable, Tutorial>()
        snapshot.appendSections([0])
        snapshot.appendItems(Tutorial.allCases)
        apply(snapshot)
    }
}

// MARK: - Private Functions
extension MainDataSource {
    
    func updateMeasureState(isMeasuring: Bool) {
        guard let row = snapshot().indexOfItem(.measure) else { return }
        let indexPath = IndexPath(row: row, section: 0)
        guard let tutorial = itemIdentifier(for: indexPath), let cell = tableView?.cellForRow(at: indexPath) else { return }
        let text = isMeasuring ? "finish" : "start"
        cell.textLabel?.text = "\(tutorial.rawValue) - \(text)"
    }
}

// MARK: - UITableViewDelegate
extension MainDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tutorial = itemIdentifier(for: indexPath) else { return }
        _result.send(tutorial)
    }
}
