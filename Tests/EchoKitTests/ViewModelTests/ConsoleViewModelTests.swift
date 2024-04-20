//
//  ConsoleViewModelTests.swift
//  
//
//  Created by Doyoung Song on 4/19/24.
//

import XCTest
@testable import EchoKit

final class ConsoleViewModelTests: XCTestCase {

    private var sut: ConsoleViewModel!

    override func setUpWithError() throws {
        sut = ConsoleViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
}
