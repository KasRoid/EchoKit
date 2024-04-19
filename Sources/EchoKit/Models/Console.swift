//
//  Console.swift
//
//
//  Created by Lukas on 4/19/24.
//

import UIKit

public struct Console {
    
    internal static let buffer = Buffer.shared
    
    private static var keyWindow: UIWindow? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window
    }

    private init() {}
}

// MARK: - Public Methods
extension Console {

    public static func start() {
        let console = ConsoleView(frame: .zero)
        console.width = UIView.screenWidth
        console.height = UIView.screenHeight / 3
        console.frame.origin = .init(x: 0, y: UIView.screenHeight - console.height)
        console.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        guard let keywindow = keyWindow else { return }
        keywindow.addSubview(console)
    }
    
    public static func echo(_ text: String, level: Level = .debug) {
        let log = Log(text: text, level: level)
        buffer.send(.append(log: log))
    }
}

// MARK: - Methods
extension Console {
    
    internal static func addDivider() {
        let log = Log(text: "==========", level: .info)
        buffer.send(.append(log: log))
    }
}
