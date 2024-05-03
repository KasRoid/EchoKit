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
    
    private let _result = PassthroughSubject<Tutorial, Never>()
    var result: AnyPublisher<Tutorial, Never> { _result.eraseToAnyPublisher() }
    
    init(tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = itemIdentifier.rawValue
            cell.selectionStyle = .none
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

// MARK: - UITableViewDelegate
extension MainDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tutorial = itemIdentifier(for: indexPath) else { return }
        print("Tapped \(tutorial.rawValue), IndexPath: \(indexPath)")
        _result.send(tutorial)
    }
}
