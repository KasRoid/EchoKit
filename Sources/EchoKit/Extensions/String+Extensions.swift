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
    
    var unprettyJSON: String {
        guard let data = data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let compactData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
              let string = String(data: compactData, encoding: .utf8) else { return self }
        return string
    }
    
    var prettyJSON: String? {
        guard let data = self.data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
              let string = String(data: prettyData, encoding: .utf8) else { return nil }
         return string
    }
}
