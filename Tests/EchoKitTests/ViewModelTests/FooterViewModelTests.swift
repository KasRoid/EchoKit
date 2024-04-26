//
//  FooterViewModelTests.swift
//  
//
//  Created by Doyoung Song on 4/19/24.
//

import Combine
import XCTest
@testable import EchoKit

final class FooterViewModelTests: XCTestCase {

    private var sut: FooterViewModel!
    private var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        sut = FooterViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testLogCountPublisher() {
        Buffer.shared.send(.clear)
        var receivedValues: [Int] = []
        sut.logCount
            .sink { receivedValues.append($0) }
            .store(in: &cancellables)
        
        let count = 3
        var expectedValue: [Int] = [0]
        for number in 1...count {
            Console.echo("\(number)")
            expectedValue.append(number)
        }
        XCTAssertEqual(expectedValue, receivedValues)
    }
}
