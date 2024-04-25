//
//  HeaderViewModelTests.swift
//  
//
//  Created by Doyoung Song on 4/19/24.
//

import Combine
import XCTest
@testable import EchoKit

final class HeaderViewModelTests: XCTestCase {
    
    private var sut: HeaderViewModel!
    private let subject = PassthroughSubject<Bool, Never>()
    private var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        let publisher = subject.eraseToAnyPublisher()
        sut = HeaderViewModel(isQuitablePublisher: publisher)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testPublisher() {
        let sendingAction: HeaderViewModel.Action = .adjustWindow(.close)
        var receivedAction: HeaderViewModel.Action?
        
        sut.publisher
            .sink { receivedAction = $0 }
            .store(in: &cancellables)
        sut.send(sendingAction)
        XCTAssertEqual(sendingAction, receivedAction)
    }
    
    func testMoreActionsList() {
        subject.send(false)
        XCTAssertEqual(sut.moreActions, [.systemInfo, .buidInfo, .share, .divider, .copy, .clear])
        
        subject.send(true)
        XCTAssertEqual(sut.moreActions, [.quit])
    }
}
