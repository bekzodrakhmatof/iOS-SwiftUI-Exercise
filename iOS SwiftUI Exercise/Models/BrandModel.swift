//
//  BrandModel.swift
//  iOS SwiftUI Exercise
//
//  Created by Bekzod Rakhmatov on 19/12/23.
//

import Foundation

struct GetBrands: Codable {
    let success: Bool
    let message: String
    let brands: [Brand]
}

struct Brand: Codable, Identifiable {
    let id: String
    let name: String
    let createdAt: String
    let updatedAt: String
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case createdAt = "created-at"
        case updatedAt = "updated-at"
    }
}
