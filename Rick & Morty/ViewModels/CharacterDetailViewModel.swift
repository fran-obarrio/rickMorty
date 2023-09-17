//
//  CharacterDetailViewModel.swift
//  Rick & Morty
//
//  Created by Francisco Obarrio on 15/09/2023.
//

import UIKit

class CharacterDetailViewModel {
    
    // MARK: - Properties
    private var networkService = NetworkService()
    
    var character: Character?
    var location: Location?
    
    var characterName: String {
        return character?.name ?? ""
    }
    
    var characterImageURL: String {
        return character?.image ?? ""
    }
    
    var characterLocationName: String {
        return character?.location.name ?? ""
    }
    
    var characterGender: String {
        return character?.gender ?? ""
    }
    
    var characterSpecies: String {
        return character?.species ?? ""
    }
    
    var characterOrigin: String {
        return character?.origin.name ?? ""
    }

    var characterLocationType: String {
        return location?.type ?? ""
    }
    
    var characterLocationDimension: String {
        return location?.dimension ?? ""
    }
    
    // MARK: - Initializer
    init(character: Character) {
        self.character = character
    }
    
    func fetchLocation(completion: @escaping (Result<Location, NetworkError>) -> Void) {
        guard let locationURL = character?.location.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        networkService.fetchLocation(from: locationURL) { [weak self] (result) in
            switch result {
            case .success(let location):
                self?.location = location
                completion(.success(location))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


}
