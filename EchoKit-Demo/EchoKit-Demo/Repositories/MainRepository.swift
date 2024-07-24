//
//  MainRepository.swift
//  EchoKit-Demo
//
//  Created by Lukas on 7/24/24.
//

import Combine
import Foundation

protocol MainRepository {
    var todos: AnyPublisher<String?, URLError> { get }
}

struct MainRepositoryModel: MainRepository {
    
    var todos: AnyPublisher<String?, URLError> {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { String(data: $0.data, encoding: .utf8) }
            .eraseToAnyPublisher()
    }
}
