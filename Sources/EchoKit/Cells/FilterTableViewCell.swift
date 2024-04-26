//
//  FilterTableViewCell.swift
//  
//
//  Created by Lukas on 4/26/24.
//

import UIKit

internal final class FilterTableViewCell: BaseTableViewCell {
 
    internal static let identifier = String(describing: FilterTableViewCell.self)
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var checkmarkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
}

// MARK: - Methods
extension FilterTableViewCell {
    
    internal func prepare(title: String, isSelected: Bool) {
        titleLabel.text = title
        checkmarkImageView.isHidden = !isSelected
    }
    
    internal func update(isSelected: Bool) {
        checkmarkImageView.isHidden = !isSelected
    }
}

// MARK: - UI
extension FilterTableViewCell {
    
    private func setupUI() {
        selectionStyle = .none
    }
}
