//
//  FavoriteService.swift
//  Rick & Morty
//
//  Created by Francisco Obarrio on 16/09/2023.
//
import UIKit

class FavoritesService {
    
    private let favoritesKey = "favorites"
    
    func saveFavorite(characterId: Int) {
        var favorites = getFavorites()
        favorites.insert(characterId)
        UserDefaults.standard.setValue(Array(favorites), forKey: favoritesKey)
    }
    
    func removeFavorite(characterId: Int) {
        var favorites = getFavorites()
        favorites.remove(characterId)
        UserDefaults.standard.setValue(Array(favorites), forKey: favoritesKey)
    }
    
    func isFavorite(characterId: Int) -> Bool {
        return getFavorites().contains(characterId)
    }
    
    private func getFavorites() -> Set<Int> {
        let favoritesArray = UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
        return Set(favoritesArray)
    }
}
