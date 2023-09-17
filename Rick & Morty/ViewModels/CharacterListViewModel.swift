//
//  CharacterListViewModel.swift
//  Rick & Morty
//
//  Created by Francisco Obarrio on 15/09/2023.
//

class CharacterListViewModel {
    var characters: [Character] = []
    let favoritesService = FavoritesService()
    
    private var networkService: NetworkServiceProtocol // Declare as protocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func fetchCharacters(page: Int, completion: @escaping (Result<[Character], NetworkError>) -> Void) {
        networkService.fetchCharacters(page: page) { result in
            switch result {
            case .success(let newCharacters):
                self.characters.append(contentsOf: newCharacters)
                completion(.success(newCharacters))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
        
    func toggleFavorite(character: Character) {
        if favoritesService.isFavorite(characterId: character.id) {
            favoritesService.removeFavorite(characterId: character.id)
        } else {
            favoritesService.saveFavorite(characterId: character.id)
        }
        if let index = characters.firstIndex(where: { $0.id == character.id }) {
            characters[index].isFavorite = !characters[index].isFavorite
        }
    }
}
