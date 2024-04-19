//
//  UIColor+Extensions.swift
//
//
//  Created by Lukas on 4/19/24.
//

import UIKit

extension UIColor {
    
    convenience init(level: Level) {
        switch level {
        case .debug:
            self.init(cgColor: UIColor.lightGray.cgColor)
        case .info:
            self.init(cgColor: UIColor.white.cgColor)
        case .warning:
            self.init(cgColor: UIColor.yellow.cgColor)
        case .error:
            self.init(cgColor: UIColor.orange.cgColor)
        case .critical:
            self.init(cgColor: UIColor.red.cgColor)
        case .fatal:
            self.init(cgColor: UIColor.orange.cgColor)
        }
    }
}
