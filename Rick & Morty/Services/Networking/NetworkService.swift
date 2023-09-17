//
//  NetworkService.swift
//  Rick & Morty
//
//  Created by Francisco Obarrio on 15/09/2023.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case urlError
    case dataError
    case decodingError
    case dataNotAvailable
    case invalidURL
    
    var errorDescription: String? {
        switch self {
        case .dataError:
            return "Server responded with an error."
        case .urlError:
            return "urlError"
        case .decodingError:
            return "decodingError"
        case .dataNotAvailable:
            return "dataNotAvailable"
        case .invalidURL:
            return "invalidURL"
        }
        
    }
}

class NetworkService: NetworkServiceProtocol {
    
    private let baseURL = "https://rickandmortyapi.com/api/"
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchCharacters(page: Int, completion: @escaping (Result<[Character], NetworkError>) -> Void) {
        guard let url = URL(string: "\(baseURL)character/?page=\(page)") else {
            completion(.failure(.urlError))
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(.dataError))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ResponseWrapper<Character>.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
    
    func fetchLocation(from url: String, completion: @escaping (Result<Location, NetworkError>) -> Void) {
        guard let url =  URL(string: url) else {
            completion(.failure(.urlError))
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(.dataError))
                return
            }
            
            do {
                let location = try JSONDecoder().decode(Location.self, from: data)
                completion(.success(location))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
        
    }
}

struct ResponseWrapper<T: Codable>: Codable {
    let results: [T]
}
