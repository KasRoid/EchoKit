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
            self.init(cgColor: UIColor.systemTeal.cgColor)
        case .debug:
            self.init(cgColor: UIColor.brown.cgColor)
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
    
    static let close = UIColor(red: 1.0, green: 0.3647, blue: 0.3725, alpha: 1.0)
    static let minimize = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)
    static let fullscreen = UIColor(red: 0.3294, green: 0.8471, blue: 0.3137, alpha: 1.0)
}
