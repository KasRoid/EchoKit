//
//  UserDefaults+Extensions.swift
//  EchoKit
//
//  Created by Lukas on 10/28/24.
//

import Foundation

extension UserDefaults {
    
    func set(_ point: CGPoint, forKey key: String) {
        let pointDict = ["x": point.x, "y": point.y]
        set(pointDict, forKey: key)
    }
    
    func cgPoint(forKey key: String) -> CGPoint? {
        guard let pointDict = dictionary(forKey: key) as? [String: CGFloat],
              let x = pointDict["x"],
              let y = pointDict["y"] else {
            return nil
        }
        return CGPoint(x: x, y: y)
    }
}
