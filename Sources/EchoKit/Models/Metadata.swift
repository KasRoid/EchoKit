//
//  Metadata.swift
//
//
//  Created by Lukas on 4/29/24.
//

internal enum MetadataType: String, CaseIterable {
    case file
    case function = "Func"
    case line
    case time
    case filterKey = "Fkey"
}

internal struct Metadata: Hashable {
    internal let type: MetadataType
    internal let content: String
}
