//
//  HeaderViewModelTests.swift
//  
//
//  Created by Doyoung Song on 4/19/24.
//

import XCTest
@testable import EchoKit

final class HeaderViewModelTests: XCTestCase {
    
    private var sut: HeaderViewModel!

    override func setUpWithError() throws {
        sut = HeaderViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
}
