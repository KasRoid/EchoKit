//
//  ConsoleViewModel.swift
//  
//
//  Created by Lukas on 4/19/24.
//

import Combine

internal final class ConsoleViewModel {
    
    @Published private(set) var isActivePublisher: AnyPublisher<Bool, Never>
    
    init(publisher: AnyPublisher<Bool, Never>) {
        isActivePublisher = publisher
    }
}
