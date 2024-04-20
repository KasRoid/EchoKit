//
//  FooterViewModelTests.swift
//  
//
//  Created by Doyoung Song on 4/19/24.
//

import XCTest
@testable import EchoKit

final class FooterViewModelTests: XCTestCase {

    private var sut: FooterViewModel!

    override func setUpWithError() throws {
        sut = FooterViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
}
