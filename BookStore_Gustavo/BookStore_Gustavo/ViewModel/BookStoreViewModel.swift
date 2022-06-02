//
//  BookStoreViewModel.swift
//  BookStore_Gustavo
//
//  Created by Gustavo Oliveira on 01/06/22.
//

import Foundation

protocol FetchBookStore: class {
    func didFetch(bookStore: BookStore, books: [Item])
    func didntFetch(error: Error?)
}

class BookStoreViewModel {
    
    weak var delegate: FetchBookStore?
    private var favoritekey = "FavoritesBooks"
    
    func fetchBooks(maxResults: String, startIndex: String) {
        BookStoreServices.makeRequest(maxResults: maxResults, startIndex: startIndex) {  bookStore, error in
            guard let delegate = self.delegate else {
                return
            }

            if let bookStore = bookStore, let books = bookStore.items {
                delegate.didFetch(bookStore: bookStore, books: books)
            } else {
                delegate.didntFetch(error: error)
            }
        }
    }
    
    func setFavorites(id: String) {
        let defaults = UserDefaults.standard
        var favorites = getFavorites()
        if favorites.contains(id) {
            let newFavorites = favorites.filter { $0 != id }
            defaults.set(newFavorites, forKey: favoritekey)
        } else {
            favorites.append(id)
            defaults.set(favorites, forKey: favoritekey)
        }
        defaults.synchronize()
    }
    
    func getFavorites() -> [String] {
        let defaults = UserDefaults.standard
        return defaults.array(forKey: favoritekey)  as? [String] ?? [String]()
    }
}
