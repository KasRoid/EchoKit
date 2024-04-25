//
//  DetailDataSource.swift
//
//
//  Created by Lukas on 4/24/24.
//

import UIKit

internal final class DetailDataSource: UITableViewDiffableDataSource<Section, String> {
    
    internal typealias DetailCell = DetailTableViewCell
    
    private weak var tableView: UITableView?
    
    internal init(tableView: UITableView) {
        self.tableView = tableView
        super.init(tableView: tableView) { tableView, indexPath, text in
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.identifier, for: indexPath) as? DetailCell
            cell?.prepare(text: text)
            return cell
        }
        tableView.register(DetailCell.identifier.nib(bundle: .module), forCellReuseIdentifier: DetailCell.identifier)
    }
    
    internal func update(log: Log) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems([log.text])
        apply(snapshot, animatingDifferences: false)
    }
}
