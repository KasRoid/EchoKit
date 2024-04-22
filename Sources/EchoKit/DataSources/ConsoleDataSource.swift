//
//  ConsoleDataSource.swift
//
//
//  Created by Lukas on 4/22/24.
//

import UIKit

internal final class ConsoleDataSource: UITableViewDiffableDataSource<Section, Log> {
    
    internal typealias ConsoleCell = ConsoleTextTableViewCell
    
    internal init(logs: [Log], tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, log in
            let cell = tableView.dequeueReusableCell(withIdentifier: ConsoleCell.identifier, for: indexPath) as? ConsoleCell
            cell?.prepare(log: log)
            return cell
        }
        tableView.register(ConsoleCell.identifier.nib(bundle: .module), forCellReuseIdentifier: ConsoleCell.identifier)
    }
    
    internal func update(logs: [Log]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Log>()
        snapshot.appendSections([.main])
        snapshot.appendItems(logs)
        apply(snapshot, animatingDifferences: false)
    }
}
