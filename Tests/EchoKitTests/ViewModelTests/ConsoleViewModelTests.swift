//
//  ConsoleViewModelTests.swift
//  
//
//  Created by Doyoung Song on 4/19/24.
//

import Combine
import XCTest
@testable import EchoKit

final class ConsoleViewModelTests: XCTestCase {

    private var sut: ConsoleViewModel!
    private var subject = PassthroughSubject<Bool, Never>()
    private var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        sut = ConsoleViewModel(.test, publisher: subject.eraseToAnyPublisher())
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testIsActivePublisherReceivesUpdate() {
        let sendingValues = [true, false]
        var receivedValues: [Bool] = []
        
        sut.isActivePublisher
            .sink { receivedValues.append($0) }
            .store(in: &cancellables)
        
        for value in sendingValues {
            subject.send(value)
        }
        XCTAssertEqual(sendingValues, receivedValues)
    }
    
    func testCopyText() {
        let texts = Buffer.shared.allTexts
        sut.send(.copy)
        XCTAssertEqual(texts, sut.pasteboard.string)
    }
}
