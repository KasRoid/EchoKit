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
        console.width = UIView.screenWidth
        console.height = UIView.screenHeight / 3
        console.frame.origin = .init(x: 0, y: UIView.screenHeight - console.height)
        console.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        guard let keywindow = UIWindow.keyWindow else { return }
        keywindow.addSubview(console)
    }
}

// MARK: - Bindings
extension Console {
    
    private func bind() {
        consoleActiveCancellable = Notification.consoleDidTogglePublisher
            .sink { [weak self] in self?.isConsoleActive = $0 }
    }
}
