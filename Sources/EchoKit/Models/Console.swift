//
//  Console.swift
//
//
//  Created by Lukas on 4/19/24.
//

import Combine
import UIKit

public final class Console {
    
    private static var shared: Console?
    internal static let buffer = Buffer.shared
    private var consoleWindow: ConsoleWindow?
    
    @Published private(set) var isConsoleActive = false
    private var consoleActiveCancellable: AnyCancellable?
    
    private init() {
        bind()
    }
}

// MARK: - Public Methods
extension Console {
    
    public static func start() {
        makeConsole()
        setupWindow()
        setupConsole()
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

// MARK: - Private Functions
extension Console {
    
    private static func makeConsole() {
        guard shared == nil else { return }
        shared = Console()
    }
    
    private static func setupConsole() {
        guard let shared else { return }
        let publisher = shared.$isConsoleActive.eraseToAnyPublisher()
        let viewModel = ConsoleViewModel(publisher: publisher)
        let console = ConsoleView(viewModel: viewModel)
        shared.consoleWindow?.addSubview(console)
    }
    
    private static func setupWindow() {
        let scenes = UIApplication.shared.connectedScenes
        guard let windowScene = scenes.first as? UIWindowScene else { return }
        let window = ConsoleWindow(windowScene: windowScene)
        window.frame = UIScreen.main.bounds
        window.windowLevel = .alert + 1
        DispatchQueue.main.async {
            window.makeKeyAndVisible()            
        }
        shared?.consoleWindow = window
    }
}

// MARK: - Bindings
extension Console {
    
    private func bind() {
        consoleActiveCancellable = Notification.consoleDidTogglePublisher
            .sink { [weak self] in self?.isConsoleActive = $0 }
    }
}
