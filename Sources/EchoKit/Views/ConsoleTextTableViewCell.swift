//
//  ConsoleTextTableViewCell.swift
//  
//
//  Created by Lukas on 4/22/24.
//

import UIKit

internal final class ConsoleTextTableViewCell: UITableViewCell {

    internal static let identifier = String(describing: ConsoleTextTableViewCell.self)
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private var log: Log?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - Methods
extension ConsoleTextTableViewCell {
    
    internal func prepare(log: Log) {
        self.log = log
        timeLabel.text = log.date.HHmmss
        descriptionLabel.text = log.text
    }
}
