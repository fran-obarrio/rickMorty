//
//  MockNetworkService.swift
//  Rick & Morty
//
//  Created by Francisco Obarrio on 15/09/2023.
//

import Foundation

class MockNetworkService: NetworkServiceProtocol {    
    
    var characterResult: Result<[Character], NetworkError>?
    var locationResult: Result<Location, NetworkError>?
    
    func fetchCharacters(page: Int, completion: @escaping (Result<[Character], NetworkError>) -> Void) {
        if let result = characterResult {
            completion(result)
        } else {
            completion(.failure(.dataNotAvailable))
        }
    }

    func fetchLocation(from url: String, completion: @escaping (Result<Location, NetworkError>) -> Void) {
        if let result = locationResult {
            completion(result)
        } else {
            completion(.failure(.dataNotAvailable))
        }
    }
}
