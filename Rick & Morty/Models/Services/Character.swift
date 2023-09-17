//
//  Character.swift
//  Rick & Morty
//
//  Created by Francisco Obarrio on 15/09/2023.
//

struct Character: Codable {
    let id: Int
    let name: String
    let gender: String
    let status: String
    let species: String
    let image: String
    let location: Location
    let origin: Origin
    var isFavorite: Bool = false
    
    // For Unit Testing 
    init(id: Int, name: String, gender: String, status: String, species: String, image: String, location: Location, origin: Origin) {
           self.id = id
           self.name = name
           self.gender = gender
           self.status = status
           self.species = species
           self.image = image
           self.location = location
           self.origin = origin
       }
    
    // To avoid problems with isFavorite since its not in the data struct
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        gender = try container.decode(String.self, forKey: .gender)
        status = try container.decode(String.self, forKey: .status)
        species = try container.decode(String.self, forKey: .species)
        image = try container.decode(String.self, forKey: .image)
        location = try container.decode(Location.self, forKey: .location)
        origin = try container.decode(Origin.self, forKey: .origin)
        isFavorite = false
    }
    
}


struct Origin: Codable {
    let name: String
    let url: String
}

// This allow the struct to be able to be compared
extension Character: Equatable {
    static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.image == rhs.image &&
        lhs.location == rhs.location
    }
}
