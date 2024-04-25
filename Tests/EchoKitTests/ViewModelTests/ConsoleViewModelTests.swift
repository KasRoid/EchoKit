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
        sut = ConsoleViewModel(.test)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testInitializer() {
        let mockViewModel = ConsoleViewModel(.test)
        let mockPasteboard = mockViewModel.pasteboard as? MockPasteboard
        XCTAssertTrue(mockPasteboard != nil)
        
        let productionViewModel = ConsoleViewModel(.production)
        let systemPasteboard = productionViewModel.pasteboard as? SystemPasteboard
        XCTAssertTrue(systemPasteboard != nil)
    }
    
    func testClearLogs() {
        sut.send(.clear)
        let isEmpty = Buffer.shared.logs.isEmpty
        XCTAssertTrue(isEmpty)
    }
    
    func testCopyLogs() {
        let texts = Buffer.shared.fullLogs
        sut.send(.copy)
        XCTAssertEqual(texts, sut.pasteboard.string)
    }
    
    func testAddDivider() {
        sut.send(.divider)
        let isDivider = Buffer.shared.logs.last?.text.contains("==========") ?? false
        XCTAssertTrue(isDivider)
    }
}
