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
        case .notice:
            self.init(cgColor: UIColor.brown.cgColor)
        case .debug:
            self.init(cgColor: UIColor.systemTeal.cgColor)
        case .info:
            self.init(cgColor: UIColor.white.cgColor)
        case .trace:
            self.init(cgColor: UIColor.green.cgColor)
        case .warning:
            self.init(cgColor: UIColor.yellow.cgColor)
        case .error:
            self.init(cgColor: UIColor.orange.cgColor)
        case .fault:
            self.init(cgColor: UIColor.magenta.cgColor)
        case .critical:
            self.init(cgColor: UIColor.red.cgColor)
        }
    }
}
