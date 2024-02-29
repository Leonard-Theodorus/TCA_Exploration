//
//  CartItem.swift
//  Numbers
//
//  Created by Alonica🐦‍⬛🐺 on 27/02/24.
//

import Foundation

struct CartItem : Identifiable, Equatable{
    let id : UUID
    let product : Product
    var quantity : Int
}

extension CartItem : Encodable{
    private enum CodingKeys : String, CodingKey{
        case productId
        case quantity
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(product.id, forKey: .productId)
        try container.encode(quantity, forKey: .quantity)
    }
}

extension CartItem{
    static let mock : [CartItem] = [
        .init(id: UUID(), product: Product.mock[0], quantity: 4),
        .init(id: UUID(), product: Product.mock[1], quantity: 2),
        .init(id: UUID(), product: Product.mock[2], quantity: 5),
    ]
}
