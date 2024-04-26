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
        sut = ConsoleViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testActivateWindow() {
        sut.send(.activateWindow)
        XCTAssertTrue(sut.windowState == .windowed)
    }
    
    func testAdjustWindow() {
        sut.send(.adjustWindow(.close))
        XCTAssertTrue(sut.windowState == .closed)
        
        sut.send(.adjustWindow(.minimize))
        XCTAssertTrue(sut.windowState == .minimized)
        
        sut.send(.adjustWindow(.zoom))
        XCTAssertTrue(sut.windowState == .windowed)
        
        sut.send(.adjustWindow(.zoom))
        XCTAssertTrue(sut.windowState == .fullscreen)
    }
    
    func testRepeatedClosedWindowAction() {
        var count = 0
        
        sut.$windowState
            .dropFirst()
            .sink { _ in count += 1 }
            .store(in: &cancellables)
        
        sut.send(.adjustWindow(.close))
        sut.send(.adjustWindow(.close))
        sut.send(.adjustWindow(.close))
        
        XCTAssertTrue(count == 1)
    }
    
    func testRepeatedMinimizeWindowAction() {
        var count = 0
        
        sut.$windowState
            .dropFirst()
            .sink { _ in count += 1 }
            .store(in: &cancellables)
        
        sut.send(.adjustWindow(.minimize))
        sut.send(.adjustWindow(.minimize))
        sut.send(.adjustWindow(.minimize))
        
        XCTAssertTrue(count == 1)
    }
}
