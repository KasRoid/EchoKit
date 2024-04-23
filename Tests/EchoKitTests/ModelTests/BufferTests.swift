//
//  BufferTests.swift
//  
//
//  Created by Lukas on 4/19/24.
//

import XCTest
@testable import EchoKit

final class BufferTests: XCTestCase {

    private var sut: Buffer!
    
    override func setUpWithError() throws {
        sut = Buffer.shared
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testAppendLog() {
        let log = Log(text: "Some Log", level: .info)
        sut.send(.append(log: log))
        XCTAssertEqual(log, sut.logs.first)
        XCTAssertTrue(sut.logs.count == 1)
    }
    
    func testClearLogs() {
        sut.send(.clear)
        XCTAssertTrue(sut.logs.isEmpty)
    }
}
