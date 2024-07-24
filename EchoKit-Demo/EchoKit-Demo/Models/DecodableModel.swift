//
//  DecodableModel.swift
//  EchoKit-Demo
//
//  Created by Lukas on 7/24/24.
//

import Foundation

struct Todo: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}
