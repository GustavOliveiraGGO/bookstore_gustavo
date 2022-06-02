//
//  BookStore_GustavoTests.swift
//  BookStore_GustavoTests
//
//  Created by Gustavo Oliveira on 01/06/22.
//

import XCTest
@testable import BookStore_Gustavo

class BookStore_GustavoTests: XCTestCase {

    private let favoriteKey = "FavoritesBooksTest"
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetFavoriteEmptyList() throws {
        let defaults = UserDefaults.standard
        let emptyList = defaults.array(forKey: favoriteKey) as? [String] ?? [String]()
        XCTAssertNotNil(emptyList)
    }
    
    func testSetFavorite() throws {
        let defaults = UserDefaults.standard
        let favorites = ["1", "23", "456"]
        defaults.set(favorites, forKey: favoriteKey)
        defaults.synchronize()
        let notEmptyList = defaults.array(forKey: favoriteKey) as? [String] ?? [String]()
        XCTAssertNotNil(notEmptyList)
        XCTAssertEqual(notEmptyList.count, 3)
    }
    
    func testRemoveFavorite() throws {
        let defaults = UserDefaults.standard
        let favorites = ["1", "23", "456"]
        let id = "23"
        let newFavorites = favorites.filter { $0 != id }
        defaults.set(newFavorites, forKey: favoriteKey)
        defaults.synchronize()
        let notEmptyList = defaults.array(forKey: favoriteKey) as? [String] ?? [String]()
        XCTAssertNotNil(notEmptyList)
        XCTAssertEqual(notEmptyList.count, 2)
    }
    
    func testRemoveAllFavorite() throws {
        let defaults = UserDefaults.standard
        let favorites: [String] = []
        defaults.set(favorites, forKey: favoriteKey)
        defaults.synchronize()
        let notEmptyList = defaults.array(forKey: favoriteKey) as? [String] ?? [String]()
        XCTAssertNotNil(notEmptyList)
        XCTAssertEqual(notEmptyList.count, 0)
    }
}
