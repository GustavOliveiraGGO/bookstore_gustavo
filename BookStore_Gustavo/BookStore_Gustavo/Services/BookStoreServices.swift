//
//  BookStoreRest.swift
//  BookStore_Gustavo
//
//  Created by Gustavo Oliveira on 01/06/22.
//

import Foundation
import Alamofire
import UIKit

class BookStoreServices {
    private static let baseURL = "https://www.googleapis.com/"
    private static let books = "books/v1/volumes"
    
    static func makeRequest(maxResults: String, startIndex: String, completion: @escaping (BookStore?, Error?) -> Void) {
        var params: Parameters = [
            "q": "iOS",
            "maxResults": maxResults,
            "startIndex": startIndex
        ]

        let url = baseURL+books
        AF.request(url,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default).response { response in
            let decoder = JSONDecoder()
            if let data = response.data {
                do {
                    let bookStore = try decoder.decode(BookStore.self, from: data)
                    completion(bookStore, nil)
                } catch {
                    completion(nil, error)
                }
            }
        }
    }
}
