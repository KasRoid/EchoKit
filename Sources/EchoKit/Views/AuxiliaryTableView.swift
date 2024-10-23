//
//  AuxiliaryTableView.swift
//  EchoKit
//
//  Created by Lukas on 10/23/24.
//

import Combine
import UIKit

internal final class AuxiliaryTableView: UITableView, UIContextMenuInteractionDelegate {
    
    internal var tap: AnyPublisher<Void, Never> { _tap.eraseToAnyPublisher() }
    internal var interaction: AnyPublisher<(text: String, interaction: Interaction), Never> { _interaction.eraseToAnyPublisher() }
    
    private let _tap = PassthroughSubject<Void, Never>()
    private let _interaction = PassthroughSubject<(text: String, interaction: Interaction), Never>()
    private(set) var isLatestData = true
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        delegate = self
    }
    
    internal func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let convertedLocation = convert(location, from: interaction.view)
        guard let indexPath = indexPathForRow(at: convertedLocation),
              let dataSource = dataSource as? DetailDataSource,
              let text = dataSource.itemIdentifier(for: indexPath) as? String else { return nil }
        
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

// MARK: - UITableViewDelegate
extension AuxiliaryTableView: UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _tap.send()
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
