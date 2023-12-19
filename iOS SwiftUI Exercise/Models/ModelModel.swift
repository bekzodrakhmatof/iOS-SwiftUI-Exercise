//
//  ModelModel.swift
//  iOS SwiftUI Exercise
//
//  Created by Bekzod Rakhmatov on 19/12/23.
//

import Foundation

struct GetModels: Codable {
    let success: Bool
    let message: String
    let models: [Model]
}

struct Model: Codable, Identifiable {
    let id: String
    let name: String
    let brand: String
    let createdAt: String
    let updatedAt: String
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case brand
        case createdAt = "created-at"
        case updatedAt = "updated-at"
    }
}
