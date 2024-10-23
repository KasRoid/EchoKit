//
//  DetailDataSource.swift
//
//
//  Created by Lukas on 4/24/24.
//

import UIKit

internal final class DetailDataSource: UITableViewDiffableDataSource<Section, AnyHashable> {
    
    internal typealias ConsoleCell = ConsoleTextTableViewCell
    internal typealias DetailCell = DetailTableViewCell
    
    internal init(tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, item in
            if let item = item as? Metadata {
                let cell = tableView.dequeueReusableCell(withIdentifier: ConsoleCell.identifier, for: indexPath) as? ConsoleCell
                cell?.prepare(metadata: item)
                for interaction in (cell?.interactions ?? []) where interaction is UIContextMenuInteraction {
                    cell?.removeInteraction(interaction)
                }
                if let tableView = tableView as? AuxiliaryTableView {
                    let interaction = UIContextMenuInteraction(delegate: tableView)
                    cell?.addInteraction(interaction)
                }
                return cell
            }
            
            if let item = item as? String {
                let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.identifier, for: indexPath) as? DetailCell
                cell?.prepare(text: item)
                for interaction in (cell?.interactions ?? []) where interaction is UIContextMenuInteraction {
                    cell?.removeInteraction(interaction)
                }
                if let tableView = tableView as? AuxiliaryTableView {
                    let interaction = UIContextMenuInteraction(delegate: tableView)
                    cell?.addInteraction(interaction)
                }
                return cell
            }
            return UITableViewCell()
        }
        tableView.register(ConsoleCell.identifier.nib, forCellReuseIdentifier: ConsoleCell.identifier)
        tableView.register(DetailCell.identifier.nib, forCellReuseIdentifier: DetailCell.identifier)
    }
    
    internal func update(log: Log) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            let alignedText = [log.alignedText]
            var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
            snapshot.appendSections([.metadata, .content])
            let datum = MetadataType.allCases.compactMap { type -> Metadata? in
                guard let content = self.getContent(of: type, from: log) else { return nil }
                return Metadata(type: type, content: content)
            }
            let loading = ["Loading..."]
            snapshot.appendItems(loading, toSection: .content)
            snapshot.appendItems(datum, toSection: .metadata)
            
            DispatchQueue.main.async {
                self.apply(snapshot, animatingDifferences: false)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
                    snapshot.deleteItems(loading)
                    snapshot.appendItems(alignedText, toSection: .content)
                    self.apply(snapshot, animatingDifferences: false)
                }
            }
        }
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
