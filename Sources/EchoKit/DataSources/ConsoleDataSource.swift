//
//  ConsoleDataSource.swift
//
//
//  Created by Lukas on 4/22/24.
//

import Combine
import UIKit

internal final class ConsoleDataSource: UITableViewDiffableDataSource<Section, Log> {
    
    internal typealias ConsoleCell = ConsoleTextTableViewCell
    
    internal init(tableView: ConsoleTableView) {
        super.init(tableView: tableView) { tableView, indexPath, log in
            let cell = tableView.dequeueReusableCell(withIdentifier: ConsoleCell.identifier, for: indexPath) as? ConsoleCell
            cell?.prepare(log: log)
            
            for interaction in (cell?.interactions ?? []) where interaction is UIContextMenuInteraction {
                cell?.removeInteraction(interaction)
            }
            if let tableView = tableView as? ConsoleTableView {
                let interaction = UIContextMenuInteraction(delegate: tableView)
                cell?.addInteraction(interaction)
            }
            return cell
        }
        tableView.register(ConsoleCell.identifier.nib, forCellReuseIdentifier: ConsoleCell.identifier)
    }
    
    internal func update(logs: [Log]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Log>()
        snapshot.appendSections([.content])
        snapshot.appendItems(logs)
        apply(snapshot, animatingDifferences: false)
    }
}
