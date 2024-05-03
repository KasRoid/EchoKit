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
    
    public static func register(_ logger: any EchoLevel.Type) {
        var filterKeys = logger.allCases
            	.compactMap { $0 as? any EchoLevel }
                .compactMap(\.filterKey)
                .reduce(into: Set<String>()) { $0.insert($1) }
                .filter { !$0.isEmpty }
                .sorted()
        
        filterKeys.insert("default", at: 0)
        buffer.send(.setFilterKeys(filterKeys))
    }
    
    public static func echo(_ text: String, level: Level = .info, file: String = #file, function: String = #function, line: Int = #line) {
        let log = Log(text: text, level: level, file: file, function: function, line: line)
        buffer.send(.append(log: log))
    }
    
    public static func echo(_ text: String, level: some EchoLevel, file: String = #file, function: String = #function, line: Int = #line) {
        let log = Log(text: text, level: level, file: file, function: function, line: line)
        buffer.send(.append(log: log))
    }
}

// MARK: - Private Functions
extension Console {

    private static func setupConsole() {
        let scenes = UIApplication.shared.connectedScenes
        guard let windowScene = scenes.first as? UIWindowScene else { return }
        let viewModel = ConsoleViewModel()
        let window = ConsoleWindow(windowScene: windowScene, viewModel: viewModel)
        window.frame = UIScreen.main.bounds
        window.windowLevel = .alert + 1
        DispatchQueue.main.async {
            window.makeKeyAndVisible()
        }
        shared.consoleWindow = window
    }
}
