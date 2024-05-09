//
//  String+Extensions.swift
//
//
//  Created by Lukas on 4/22/24.
//

import UIKit

internal extension String {
    
    var nib: UINib {
        #if SWIFT_PACKAGE
        let bundle = Bundle.module
        #else
        let bundle = Bundle(for: ConsoleViewController.self)
        #endif
        return UINib(nibName: self, bundle: bundle)
    }
}
