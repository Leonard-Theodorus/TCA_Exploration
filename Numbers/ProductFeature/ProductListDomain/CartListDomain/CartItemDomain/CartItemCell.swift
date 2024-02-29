//
//  CartItemCell.swift
//  Numbers
//
//  Created by Alonica🐦‍⬛🐺 on 27/02/24.
//

import SwiftUI
import ComposableArchitecture

struct CartItemCell: View {
    let store : StoreOf<CartItemDomain.CartItemDomainReducer>
    
    var body: some View {
        HStack{
            AsyncImage(url: URL(string: store.cartItem.product.imagestring)) { Image in
                Image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            } placeholder: {
                ProgressView()
            }
            
            Spacer()
            
            VStack{
                HStack{
                    Text(store.cartItem.product.name)
                    Spacer()
                }
                
                HStack{
                    Text("$\(store.cartItem.product.price.description)")
                        .padding(.bottom)
                    Spacer()
                }
                
                HStack{
                    Text("Quantity : \(store.cartItem.quantity)")
                    Spacer()
                    Button{
                        store.send(.deleteCartItem(product: store.cartItem.product))
                    } label: {
                        Image(systemName: "trash.fill")
                            .foregroundStyle(.red)
                            .padding()
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    CartItemCell(
        store: (
            Store(initialState: CartItemDomain.CartItemDomainReducer.State(id: UUID(), cartItem: CartItem(id: UUID(), product: Product.mock[0], quantity: 3)), reducer: {
                CartItemDomain.CartItemDomainReducer()
            })
        )
    )
}
