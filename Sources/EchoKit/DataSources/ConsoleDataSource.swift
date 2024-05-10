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
    
    private weak var tableView: UITableView?
    private let _tap = PassthroughSubject<Log, Never>()
    private let _interaction = PassthroughSubject<(log: Log, interaction: Interaction), Never>()
    private(set) var isLatestData = true
    
    internal var tap: AnyPublisher<Log, Never> { _tap.eraseToAnyPublisher() }
    internal var interaction: AnyPublisher<(log: Log, interaction: Interaction), Never> { _interaction.eraseToAnyPublisher() }
    
    internal init(tableView: UITableView) {
        self.tableView = tableView
        super.init(tableView: tableView) { tableView, indexPath, log in
            let cell = tableView.dequeueReusableCell(withIdentifier: ConsoleCell.identifier, for: indexPath) as? ConsoleCell
            cell?.prepare(log: log)
            return cell
        }
        tableView.register(ConsoleCell.identifier.nib, forCellReuseIdentifier: ConsoleCell.identifier)
        tableView.delegate = self
    }
    
    internal func update(logs: [Log]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Log>()
        snapshot.appendSections([.content])
        snapshot.appendItems(logs)
        apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UITableViewDelegate
extension ConsoleDataSource: UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let log = itemIdentifier(for: indexPath) else { return }
        _tap.send(log)
    }
    
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        for interaction in cell.interactions where interaction is UIContextMenuInteraction {
            cell.removeInteraction(interaction)
        }
        let interaction = UIContextMenuInteraction(delegate: self)
        cell.addInteraction(interaction)
    }
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableViewHeight = scrollView.frame.size.height
        
        if contentOffsetY <= 0 { // Top
            isLatestData = false
        } else if contentOffsetY + tableViewHeight >= contentHeight - 20 { // Bottom
            isLatestData = true
        } else {
            isLatestData = false
        }
    }
}

// MARK: - UIContextMenuInteractionDelegate
extension ConsoleDataSource: UIContextMenuInteractionDelegate {
    
    internal func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let convertedLocation = tableView?.convert(location, from: interaction.view),
              let indexPath = tableView?.indexPathForRow(at: convertedLocation), let log = itemIdentifier(for: indexPath) else { return nil }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let children = Interaction.allCases.map { interaction in UIAction(title: interaction.rawValue) { [weak self] _ in
                self?._interaction.send((log, interaction))
            }}
            return UIMenu(title: "", children: children)
        }
    }
    
    internal enum Interaction: String, CaseIterable {
        case copy = "Copy"
    }
}
