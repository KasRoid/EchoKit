//
//  EchoLevel.swift
//
//
//  Created by Lukas on 4/29/24.
//
import Foundation

public protocol EchoLevel: CaseIterable {
    
    var echoLevel: Level { get }
    var filterKey: String? { get }
}
