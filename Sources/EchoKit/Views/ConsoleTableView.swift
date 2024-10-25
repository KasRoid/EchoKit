//
//  ConsoleTableView.swift
//  EchoKit
//
//  Created by Lukas on 10/23/24.
//

import Combine
import UIKit

internal final class ConsoleTableView: UITableView {
    
    internal var tap: AnyPublisher<Log, Never> { _tap.eraseToAnyPublisher() }
    internal var interaction: AnyPublisher<(log: Log, interaction: Interaction), Never> { _interaction.eraseToAnyPublisher() }
    internal var contextMenu: AnyPublisher<Bool, Never> { _contextMenu.eraseToAnyPublisher() }
    
    private let _tap = PassthroughSubject<Log, Never>()
    private let _interaction = PassthroughSubject<(log: Log, interaction: Interaction), Never>()
    private let _contextMenu = PassthroughSubject<Bool, Never>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        delegate = self
    }
    
    internal enum Interaction: String, CaseIterable {
        case copy = "Copy"
    }
}

// MARK: - UIContextMenuInteractionDelegate
extension ConsoleTableView: UIContextMenuInteractionDelegate {
    
    internal func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let convertedLocation = convert(location, from: interaction.view)
        guard let indexPath = indexPathForRow(at: convertedLocation),
              let dataSource = dataSource as? ConsoleDataSource,
              let log = dataSource.itemIdentifier(for: indexPath) else { return nil }
        _contextMenu.send(true)
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let children = Interaction.allCases.map { interaction in UIAction(title: interaction.rawValue) { [weak self] _ in
                self?._interaction.send((log, interaction))
            }}
            return UIMenu(title: "", children: children)
        }
    }
    
    internal func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willEndFor configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        _contextMenu.send(false)
    }
}

// MARK: - UITableViewDelegate
extension ConsoleTableView: UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataSource = dataSource as? ConsoleDataSource, let log = dataSource.itemIdentifier(for: indexPath) else { return }
        _tap.send(log)
    }
}
