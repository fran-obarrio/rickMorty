//
//  Location.swift
//  Rick & Morty
//
//  Created by Francisco Obarrio on 15/09/2023.
//


struct Location: Codable {
    let id: Int?
    let name: String?
    let type: String?
    let dimension: String?
    let residents: [String]?
    let url: String?
}

// This allow the struct to be able to be compared
extension Location: Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.type == rhs.type &&
               lhs.dimension == rhs.dimension &&
               lhs.residents == rhs.residents &&
               lhs.url == rhs.url
    }
}
