//
//  PromptTableViewCell.swift
//  
//
//  Created by Lukas on 4/26/24.
//

import UIKit

internal final class PromptTableViewCell: BaseTableViewCell {

    internal static let identifier = String(describing: PromptTableViewCell.self)
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
}

// MARK: - Methods
extension PromptTableViewCell {
    
    internal func prepare(title: String, description: String?) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}

// MARK: - UI
extension PromptTableViewCell {
    
    private func setupUI() {
        selectionStyle = .none
    }
}
