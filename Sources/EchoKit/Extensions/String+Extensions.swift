//
//  String+Extensions.swift
//
//
//  Created by Lukas on 4/22/24.
//

import UIKit

internal extension String {
    
    var nib: UINib {
        UINib(nibName: self, bundle: bundle)
    }
}
