//
//  DetailTableViewCell.swift
//  
//
//  Created by Lukas on 4/24/24.
//

import UIKit

internal final class DetailTableViewCell: BaseTableViewCell {
    
    internal static let identifier = String(describing: DetailTableViewCell.self)
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private var text: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
}

// MARK: - Methods
extension DetailTableViewCell {
    
    internal func prepare(text: String) {
        self.text = text
        descriptionLabel.text = text
    }
}

// MARK: - UI
extension DetailTableViewCell {
    
    private func setupUI() {
        selectionStyle = .none
    }
}
