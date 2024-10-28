//
//  MainViewModel.swift
//  EchoKit-Demo
//
//  Created by Lukas on 5/3/24.
//

import Combine
import EchoKit
import Foundation

final class MainViewModel {
    
    @Published private(set) var isMeasuring = false
    private var finishMeasure: (() -> Void)?
    private var repository: MainRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: MainRepository) {
        self.repository = repository
    }
}

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
        case .input:
            return
        case .level:
            Console.echo("==========", level: .info)
            Console.echo("There are \(Level.allCases.count) levels as below.\n", level: .info)
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
            measure()
        case .api:
            fetch()
        }
    }
    
    private func measure() {
        if isMeasuring {
            finishMeasure?()
            finishMeasure = nil
        } else {
            Console.echo("Measure Started")
            Console.measure(task: "Measure Test") { [weak self] done in
                self?.finishMeasure = done
            }
        }
        isMeasuring.toggle()
    }
    
    private func fetch() {
        repository.todos
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                guard case .failure(let error) = $0 else { return }
                Console.echo("\(error)", level: .error)
            },
                  receiveValue: { Console.echo($0 ?? "No data", level: .info) })
            .store(in: &cancellables)
    }
}
