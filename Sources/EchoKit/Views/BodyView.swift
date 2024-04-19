//
//  File.swift
//  
//
//  Created by Lukas on 4/19/24.
//

import UIKit

internal final class BodyView: UIView {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var viewModel: BodyViewModel!
    
    init(viewModel: BodyViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupWithXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupWithXib()
    }
}

// MARK: - Methods
extension BodyView {
    
    internal func prepare(viewModel: BodyViewModel) {
        self.viewModel = viewModel
    }
}
