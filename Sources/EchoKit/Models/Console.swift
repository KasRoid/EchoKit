//
//  Console.swift
//
//
//  Created by Lukas on 4/19/24.
//

import Combine
import UIKit

public final class Console {
    
    private static var shared = Console()
    internal static let buffer = Buffer.shared
    private var consoleWindow: ConsoleWindow?
    
    private init() {}
}

// MARK: - Public Methods
extension Console {
    
    public static func start() {
        setupConsole()
    }
    
    public static func echo(_ text: String, level: Level = .debug) {
        let log = Log(text: text, level: level)
        buffer.send(.append(log: log))
    }
}

// MARK: - Private Functions
extension Console {

    private static func setupConsole() {
        let scenes = UIApplication.shared.connectedScenes
        guard let windowScene = scenes.first as? UIWindowScene else { return }
        let viewModel = ConsoleViewModel(.production)
        let window = ConsoleWindow(windowScene: windowScene, viewModel: viewModel)
        window.frame = UIScreen.main.bounds
        window.windowLevel = .alert + 1
        DispatchQueue.main.async {
            window.makeKeyAndVisible()
        }
        shared.consoleWindow = window
    }
}
