//
//  ConsoleTextTableViewCell.swift
//  
//
//  Created by Lukas on 4/22/24.
//

import UIKit

internal final class ConsoleTextTableViewCell: BaseTableViewCell {

    internal static let identifier = String(describing: ConsoleTextTableViewCell.self)
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
}

// MARK: - Methods
extension ConsoleTextTableViewCell {
    
    internal func prepare(log: Log) {
        timeLabel.text = log.date.HHmmss
        timeLabel.textColor = UIColor(level: log.level)
        descriptionLabel.text = log.text
        descriptionLabel.textColor = UIColor(level: log.level)
    }
    
    internal func prepare(metadata: Metadata) {
        timeLabel.text = metadata.type.rawValue.capitalized + ":"
        timeLabel.textColor = UIColor(level: .notice)
        descriptionLabel.text = metadata.content
        descriptionLabel.textColor = UIColor(level: .notice)
    }
}

// MARK: - UI
extension ConsoleTextTableViewCell {
    
    private func setupUI() {
        selectionStyle = .none
    }
}
