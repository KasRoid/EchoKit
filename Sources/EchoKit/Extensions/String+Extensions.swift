//
//  String+Extensions.swift
//
//
//  Created by Lukas on 4/22/24.
//

import UIKit

internal extension String {
    
    func nib(for aClass: AnyClass) -> UINib {
        #if SWIFT_PACKAGE
        let bundle: Bundle = .module
        #else
        let bundle: Bundle = Bundle(for: aClass)
        #endif
        return UINib(nibName: self, bundle: bundle)
    }
}
