//
//  BodyViewModelTests.swift
//  
//
//  Created by Doyoung Song on 4/19/24.
//

import Combine
import XCTest
@testable import EchoKit

final class BodyViewModelTests: XCTestCase {
    
    private var sut: BodyViewModel!
    private let subject = PassthroughSubject<Void, Never>()
    private var publisher: AnyPublisher<Void, Never> { subject.eraseToAnyPublisher() }
    private var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        sut = BodyViewModel(.test)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testInitializer() {
        let mockViewModel = BodyViewModel(.test)
        let mockPasteboard = mockViewModel.pasteboard as? MockPasteboard
        XCTAssertTrue(mockPasteboard != nil)
        
        let productionViewModel = BodyViewModel(.production)
        let systemPasteboard = productionViewModel.pasteboard as? SystemPasteboard
        XCTAssertTrue(systemPasteboard != nil)
    }
    
    func testCopyLog() {
        let log = Log(text: "Some Log", level: .info)
        sut.send(.copyLog(log))
        let expectedText = "\(log.date.HHmmss) \(log.text)"
        XCTAssertEqual(expectedText, sut.pasteboard.string)
    }
    
    func testSelectLog() {
        let log = Log(text: "Some Log", level: .info)
        sut.send(.showDetail(log))
        XCTAssertEqual(sut.selectedLog, log)
    }
    
    func testLogSelectedPublisher() {
        let log = Log(text: "Some Log", level: .info)
        var isQuitable = false
        
        sut.isQuitable
            .sink { isQuitable = $0 }
            .store(in: &cancellables)
        
        sut.send(.showDetail(log))
        XCTAssertTrue(isQuitable)
    }
}
