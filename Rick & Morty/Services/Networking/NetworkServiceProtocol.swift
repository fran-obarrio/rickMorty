//
//  NetworkServiceProtocol.swift
//  Rick & Morty
//
//  Created by Francisco Obarrio on 15/09/2023.
//

protocol NetworkServiceProtocol {
    func fetchCharacters(page: Int, completion: @escaping (Result<[Character], NetworkError>) -> Void)
    func fetchLocation(from url: String, completion: @escaping (Result<Location, NetworkError>) -> Void)
}
