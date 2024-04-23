//
//  Kernel.swift
//
//
//  Created by Lukas on 4/23/24.
//

import Combine
import Foundation

internal final class Kernel {
    
    internal static let shared = Kernel()
    
    @Published private(set) var cpuUsage: Double = 0
    @Published private(set) var memoryUsage: (used: Double, total: Double) = (0, 0)
    private var cancellable: AnyCancellable?
    
    private init() {
        bind()
    }
}

// MARK: - Bindings
extension Kernel {

    private func bind() {
        cancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.updateSystemInfo() }
    }
}

// MARK: - Private Functions
extension Kernel {
    
    private func updateSystemInfo() {
        cpuUsage = CPU.cpuUsagePerThread().reduce(into: 0.0) { $0 += $1.1 }
        memoryUsage = Memory.applicationUsage()
    }
}
