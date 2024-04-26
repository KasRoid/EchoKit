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
    private var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        sut = HeaderViewModel(.test)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testMoreActionsList() {
        sut.send(.changeActions(isQuitable: true))
        XCTAssertEqual(sut.moreActions, [.quit])
        
        sut.send(.changeActions(isQuitable: false))
        XCTAssertEqual(sut.moreActions, [.systemInfo, .buidInfo, .divider, .copy, .clear])
    }
}
