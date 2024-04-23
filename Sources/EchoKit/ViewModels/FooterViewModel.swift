//
//  FooterViewModel.swift
//  
//
//  Created by Lukas on 4/19/24.
//

import Combine

internal final class FooterViewModel {
    
    internal var logCount: AnyPublisher<Int, Never> {
        Buffer.shared.$logs
            .map { $0.count }
            .eraseToAnyPublisher()
    }
    
    internal var cpuUsage: AnyPublisher<Double, Never> {
        Kernel.shared.$cpuUsage
            .eraseToAnyPublisher()
    }
    
    internal var memoryUsage: AnyPublisher<(used: Double, total: Double), Never> {
        Kernel.shared.$memoryUsage
            .eraseToAnyPublisher()
    }
}
