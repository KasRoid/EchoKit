//
//  File.swift
//  
//
//  Created by Doyoung Song on 4/19/24.
//

import UIKit

internal extension UIWindow {
    
    static var keyWindow: UIWindow? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window
    }
}
