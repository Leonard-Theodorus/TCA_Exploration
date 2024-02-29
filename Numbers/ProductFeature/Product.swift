//
//  Product.swift
//  Numbers
//
//  Created by Alonica🐦‍⬛🐺 on 26/02/24.
//

import Foundation

struct Product : Identifiable, Equatable{
    let id : Int
    let name : String
    let imagestring : String
    let price : Double
    
    enum CodingKeys : String, CodingKey{
        case id
        case name = "title"
        case price
        case imagestring = "image"
    }
}

extension Product : Decodable{
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Product.CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.price = try container.decode(Double.self, forKey: .price)
        self.imagestring = try container.decode(String.self, forKey: .imagestring)
    }
}

extension Product{
    static let mock : [Product] = [
        .init(id: 1, name: "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops", imagestring: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg", price: 50000),
        .init(id: 10, name: "SanDisk SSD PLUS 1TB Internal SSD - SATA III 6 Gb/s", imagestring: "https://fakestoreapi.com/img/61U7T1koQqL._AC_SX679_.jpg", price: 40000),
        .init(id: 7, name: "White Gold Plated Princess", imagestring: "https://fakestoreapi.com/img/71YAIFU48IL._AC_UL640_QL65_ML3_.jpg", price: 75000)
    ]
}
