//
//  Pasteboard.swift
//  
//
//  Created by Lukas on 4/19/24.
//

import UIKit

internal protocol Pasteboard {
    var string: String? { get set }
}

internal final class SystemPasteboard: Pasteboard {
    
    static let shared = SystemPasteboard()
    
    var string: String? {
        get { UIPasteboard.general.string }
        set { UIPasteboard.general.string = newValue }
    }
    
    private init() {}
}

internal final class MockPasteboard: Pasteboard {
    
    static let shared = MockPasteboard()
    var string: String?
    
    private init() {}
}
