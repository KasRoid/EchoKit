//
//  ConsoleTests.swift
//  
//
//  Created by Lukas on 4/19/24.
//

import XCTest
@testable import EchoKit

final class ConsoleTests: XCTestCase {
    
    func testEcho() {
        let text = "Some text"
        Console.echo(text)
        XCTAssertEqual(text, Console.buffer.logs.last?.text)
    }
}
