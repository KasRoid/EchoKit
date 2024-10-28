//
//  Dictionary+Extensions.swift
//  EchoKit
//
//  Created by Lukas on 10/25/24.
//

import Foundation

extension Dictionary {
    
    var prettyJSON: String {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted]),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return "Invalid JSON format"
        }
        return jsonString
    }
}
