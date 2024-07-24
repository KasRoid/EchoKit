//
//  Log.swift
//
//
//  Created by Lukas on 4/19/24.
//

import Foundation

internal struct Log: Hashable, Identifiable {
    
    internal let id: UUID
    internal let date: Date
    internal let text: String
    internal let level: Level
    internal let filterKey: String
    internal let file: String
    internal let function: String
    internal let line: Int
    
    private let prettyText: String?
    
    internal var alignedText: String {
        prettyText ?? text
    }
    
    internal init(text: String, level: some EchoLevel, file: String = #file, function: String = #function, line: Int = #line) {
        self.id = UUID()
        self.date = Date()
        self.text = text
        self.level = level.echoLevel
        self.filterKey = level.filterKey ?? "default"
        self.file = file
        self.function = function
        self.line = line
        self.prettyText = text.prettyJSON
    }
}
