//
//  System.swift
//
//
//  Created by Lukas on 4/24/24.
//

import UIKit

internal final class System {
    
    internal static var osVersion: String {
        UIDevice.current.systemVersion
    }
    
    internal static var deviceModel: String {
        UIDevice.modelName
    }
    
    internal static var info: String {
        "OS: \(osVersion)"
        + "\n"
        + "Device: \(deviceModel)"
    }
}
