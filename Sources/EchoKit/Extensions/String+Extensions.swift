//
//  String+Extensions.swift
//
//
//  Created by Lukas on 4/22/24.
//

import UIKit

public extension String {
    
    func nib(bundle: Bundle? = nil) -> UINib {
        return UINib(nibName: self, bundle: bundle)
    }
}
