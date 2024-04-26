//
//  DetailDataSource.swift
//
//
//  Created by Lukas on 4/24/24.
//

import Combine
import UIKit

internal final class DetailDataSource: UITableViewDiffableDataSource<Section, String> {
    
    internal typealias DetailCell = DetailTableViewCell
    
    private weak var tableView: UITableView?
    private let _tap = PassthroughSubject<Void, Never>()
    private let _interaction = PassthroughSubject<(text: String, interaction: Interaction), Never>()
    
    internal var tap: AnyPublisher<Void, Never> { _tap.eraseToAnyPublisher() }
    internal var interaction: AnyPublisher<(text: String, interaction: Interaction), Never> { _interaction.eraseToAnyPublisher() }
    
    internal init(tableView: UITableView) {
        self.tableView = tableView
        super.init(tableView: tableView) { tableView, indexPath, text in
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.identifier, for: indexPath) as? DetailCell
            cell?.prepare(text: text)
            return cell
        }
        tableView.register(DetailCell.identifier.nib(bundle: .module), forCellReuseIdentifier: DetailCell.identifier)
        tableView.delegate = self
    }
    
    internal func update(log: Log) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.content])
        snapshot.appendItems([log.text])
        apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UITableViewDelegate
extension DetailDataSource: UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _tap.send()
    }
    
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        for interaction in cell.interactions where interaction is UIContextMenuInteraction {
            cell.removeInteraction(interaction)
        }
        let interaction = UIContextMenuInteraction(delegate: self)
        cell.addInteraction(interaction)
    }
}

// MARK: - UIContextMenuInteractionDelegate
extension DetailDataSource: UIContextMenuInteractionDelegate {
    
    internal func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = tableView?.indexPathForRow(at: location), let text = itemIdentifier(for: indexPath) else { return nil }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let children = Interaction.allCases.map { interaction in UIAction(title: interaction.rawValue) { [weak self] _ in
                self?._interaction.send((text, interaction))
            }}
            return UIMenu(title: "", children: children)
        }
    }
    
    internal enum Interaction: String, CaseIterable {
        case copy = "Copy"
    }
}
