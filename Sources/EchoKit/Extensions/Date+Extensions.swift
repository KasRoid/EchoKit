//
//  Date+Extensions.swift
//
//
//  Created by Lukas on 4/22/24.
//

import Foundation

extension Date {
    
    var HHmmss: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}
