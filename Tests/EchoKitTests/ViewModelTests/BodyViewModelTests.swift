//
//  BodyViewModelTests.swift
//  
//
//  Created by Doyoung Song on 4/19/24.
//

import XCTest
@testable import EchoKit

final class BodyViewModelTests: XCTestCase {
    
    private var sut: BodyViewModel!

    override func setUpWithError() throws {
        sut = BodyViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
}
