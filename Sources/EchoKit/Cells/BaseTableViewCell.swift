//
//  BaseTableViewCell.swift
//  
//
//  Created by Lukas on 4/24/24.
//

import UIKit

internal class BaseTableViewCell: UITableViewCell {

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
