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
        let pasteBoard = MockPasteboard.shared
        sut = BodyViewModel(environment: .test, quitPublisher: publisher)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testInitializer() {
        let mockViewModel = BodyViewModel(environment: .test, quitPublisher: publisher)
        let mockPasteboard = mockViewModel.pasteboard as? MockPasteboard
        XCTAssertTrue(mockPasteboard != nil)
        
        let productionViewModel = BodyViewModel(environment: .production, quitPublisher: publisher)
        let systemPasteboard = productionViewModel.pasteboard as? SystemPasteboard
        XCTAssertTrue(systemPasteboard != nil)
    }
    
    func testCopyLog() {
        let log = Log(text: "Some Log", level: .info)
        sut.send(.copy(log))
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
        var isLogSelected = false
        
        sut.logSelected
            .sink { isLogSelected = true }
            .store(in: &cancellables)
        sut.send(.showDetail(log))
        XCTAssertTrue(isLogSelected)
    }
}
