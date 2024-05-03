//
//  MainViewModel.swift
//  EchoKit-Demo
//
//  Created by Lukas on 5/3/24.
//

import EchoKit

final class MainViewModel {}

// MARK: - Actions
extension MainViewModel {
    
    enum Action {
        case tutorial(Tutorial)
    }
    
    func send(_ action: Action) {
        switch action {
        case .tutorial(let tutorial):
            handleTutorial(tutorial)
        }
    }
}

// MARK: - Private Functions
extension MainViewModel {
    
    private func handleTutorial(_ tutorial: Tutorial) {
        switch tutorial {
        case .about:
            let text = "Find more information on \nhttps://github.com/KasRoid/EchoKit"
            Console.echo(text, level: .notice)
        case .echo:
            let text = ""
            Console.echo(text, level: .debug)
        case .level:
            Console.echo("==========", level: .info)
            Console.echo("Notice", level: .notice)
            Console.echo("Info", level: .info)
            Console.echo("Debug", level: .debug)
            Console.echo("Trace", level: .trace)
            Console.echo("Warning", level: .warning)
            Console.echo("Error", level: .error)
            Console.echo("Fault", level: .fault)
            Console.echo("Critical", level: .critical)
            Console.echo("==========", level: .info)
        case .measure:
            let text = ""
            Console.echo(text, level: .notice)
        }
    }
}
