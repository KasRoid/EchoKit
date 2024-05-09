//
//  DetailDataSource.swift
//
//
//  Created by Lukas on 4/24/24.
//

import Combine
import UIKit

internal final class DetailDataSource: UITableViewDiffableDataSource<Section, AnyHashable> {
    
    internal typealias ConsoleCell = ConsoleTextTableViewCell
    internal typealias DetailCell = DetailTableViewCell
    
    private weak var tableView: UITableView?
    private let _tap = PassthroughSubject<Void, Never>()
    private let _interaction = PassthroughSubject<(text: String, interaction: Interaction), Never>()
    
    internal var tap: AnyPublisher<Void, Never> { _tap.eraseToAnyPublisher() }
    internal var interaction: AnyPublisher<(text: String, interaction: Interaction), Never> { _interaction.eraseToAnyPublisher() }
    
    internal init(tableView: UITableView) {
        self.tableView = tableView
        super.init(tableView: tableView) { tableView, indexPath, item in
            if let item = item as? Metadata {
                let cell = tableView.dequeueReusableCell(withIdentifier: ConsoleCell.identifier, for: indexPath) as? ConsoleCell
                cell?.prepare(metadata: item)
                return cell
            }
            if let item = item as? String {
                let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.identifier, for: indexPath) as? DetailCell
                cell?.prepare(text: item)
                return cell
            }
            return UITableViewCell()
        }
        tableView.register(ConsoleCell.identifier.nib(for: DetailDataSource.self), forCellReuseIdentifier: ConsoleCell.identifier)
        tableView.register(DetailCell.identifier.nib(for: DetailDataSource.self), forCellReuseIdentifier: DetailCell.identifier)
        tableView.delegate = self
    }
    
    internal func update(log: Log) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.metadata, .content])
        let datum = MetadataType.allCases.compactMap { type -> Metadata? in
            guard let content = getContent(of: type, from: log) else { return nil }
            return Metadata(type: type, content: content)
        }
        snapshot.appendItems(datum, toSection: .metadata)
        snapshot.appendItems([log.text], toSection: .content)
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
    
    internal func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    internal func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
}

// MARK: - UIContextMenuInteractionDelegate
extension DetailDataSource: UIContextMenuInteractionDelegate {
    
    internal func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = tableView?.indexPathForRow(at: location), let text = itemIdentifier(for: indexPath) as? String else { return nil }
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

// MARK: - Private Functions
extension DetailDataSource {
    
    private func getContent(of data: MetadataType, from log: Log) -> String? {
        switch data {
        case .file:
            URL(fileURLWithPath: log.file).lastPathComponent
        case .function:
            log.function
        case .line:
            "\(log.line)"
        case .time:
            log.date.HHmmss
        case .filterKey:
            Buffer.shared.filterKeys.isEmpty ? nil : log.filterKey
        }
    }
}
