//
//  Log.swift
//
//
//  Created by Lukas on 4/19/24.
//

import Foundation

struct Log: Hashable, Identifiable {
    let id: UUID
    let date: Date
    let text: String
    let level: Level
    
    init(text: String, level: Level) {
        self.id = UUID()
        self.date = Date()
        self.text = text
        self.level = level
    }
}
