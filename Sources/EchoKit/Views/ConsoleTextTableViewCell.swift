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
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        contentView.backgroundColor = .darkGray
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        contentView.backgroundColor = .black
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        contentView.backgroundColor = .black
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

// MARK: - UI
extension ConsoleTextTableViewCell {
    
    private func setupUI() {
        selectionStyle = .none
    }
}
