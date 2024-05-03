//
//  DetailDataSource.swift
//
//
//  Created by Lukas on 4/26/24.
//

import Combine
import UIKit

internal final class FilterDataSource<T: Hashable & CustomStringConvertible>: UITableViewDiffableDataSource<Section, AnyHashable>, UITableViewDelegate {
    
    internal typealias PromptCell = PromptTableViewCell
    internal typealias FilterCell = FilterTableViewCell
    
    private let _result = PassthroughSubject<[T], Never>()
    internal var result: AnyPublisher<[T], Never> { _result.eraseToAnyPublisher() }
    
    private weak var tableView: UITableView?
    private let filters: [T]
    
    internal init(tableView: UITableView, filters: [T]) {
        self.tableView = tableView
        self.filters = filters
        super.init(tableView: tableView) { tableView, indexPath, item in
            if let prompt = item as? Prompt {
                let cell = tableView.dequeueReusableCell(withIdentifier: PromptCell.identifier, for: indexPath) as? PromptCell
                cell?.prepare(title: prompt.title, description: prompt.description)
                return cell!
            }
            if let filter = item as? Filter {
                let cell = tableView.dequeueReusableCell(withIdentifier: FilterCell.identifier, for: indexPath) as? FilterCell
                cell?.prepare(title: filter.title, isSelected: filter.isSelected)
                return cell
            }
            return UITableViewCell()
        }
        tableView.register(PromptCell.identifier.nib(bundle: .module), forCellReuseIdentifier: PromptCell.identifier)
        tableView.register(FilterCell.identifier.nib(bundle: .module), forCellReuseIdentifier: FilterCell.identifier)
        tableView.delegate = self
    }
    
    internal func update(prompt: Prompt, selected: [T]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.prompt, .content])
        snapshot.appendItems([prompt], toSection: .prompt)
        let filters = filters.map { Filter(title: $0.description, isSelected: selected.contains($0), source: $0) }
        snapshot.appendItems(filters, toSection: .content)
        apply(snapshot, animatingDifferences: false)
    }
    
    internal func finish() {
        guard let items = snapshot().itemIdentifiers(inSection: .content) as? [Filter] else { return }
        let selected = items.filter(\.isSelected).map(\.source)
        _result.send(selected)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let filter = itemIdentifier(for: indexPath) as? Filter,
        let cell = tableView.cellForRow(at: indexPath) as? FilterCell else { return }
        filter.isSelected.toggle()
        cell.update(isSelected: filter.isSelected)
    }
}

// MARK: - Models
extension FilterDataSource {
    
    private final class Filter: Hashable {
        
        let title: String
        var isSelected: Bool
        let source: T
        
        init(title: String, isSelected: Bool, source: T) {
            self.title = title
            self.isSelected = isSelected
            self.source = source
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(title)
        }
        
        static func == (lhs: FilterDataSource<T>.Filter, rhs: FilterDataSource<T>.Filter) -> Bool {
            lhs.title == rhs.title && lhs.isSelected == rhs.isSelected
        }
    }
}
