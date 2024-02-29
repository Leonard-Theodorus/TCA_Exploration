//
//  APIClient.swift
//  Numbers
//
//  Created by Alonica🐦‍⬛🐺 on 29/02/24.
//

import Foundation

struct APIClient{
    var fetchProducts : () async throws -> [Product]
    var sendOrder : ([CartItem]) async throws -> String
    var fetchProfile : () async throws -> Profile
    struct APIError : Error {}
}

extension APIClient{
    static let liveApi = Self (
        fetchProducts : {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://fakestoreapi.com/products")!)
            let products = try JSONDecoder().decode([Product].self, from: data)
            return products
        }
        ,
        sendOrder: { items in
            let payload = try JSONEncoder().encode(items)
            var urlRequest = URLRequest(url: URL(string: "https://fakestoreapi.com/carts")!)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpMethod = "POST"
            
            let (data, response) = try await URLSession.shared.upload(for: urlRequest, from: payload)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError()
            }
            
            return "Status : \(httpResponse.statusCode)"
        }
        ,
        fetchProfile: {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://fakestoreapi.com/users/1")!)
            let profile = try JSONDecoder().decode(Profile.self, from: data)
            return profile
        }
    )
    
}
