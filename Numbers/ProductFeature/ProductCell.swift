//
//  ProductCell.swift
//  Numbers
//
//  Created by Alonica🐦‍⬛🐺 on 26/02/24.
//

import SwiftUI
import ComposableArchitecture

struct ProductCell : View{
    let store : Store<ProductDomain.ProductDomainReducer.State, ProductDomain.ProductDomainReducer.Action>
    
    var body: some View{
        VStack{
            AsyncImage(url: URL(string: store.product.imagestring)) { Image in
                
                Image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 400)
            } placeholder: {
                ProgressView()
            }
            
            
            VStack(alignment: .leading){
                Text(store.product.name)
                HStack{
                    Text("$\(store.product.price.description)")
                        .fontWeight(.bold)
                    Spacer()
                    AddToCardButton(store: store.scope(state: \.addToCartState, action: \.addToCart))
                }
            }
            .padding(20)
        }
    }
}

#Preview {
    ProductCell(store: Store(initialState: ProductDomain.ProductDomainReducer.State(
        id: UUID(), product: Product.mock[0], addToCartState: AddToCartDomain.PlusMinusReducer.State()
    ), reducer: {
        ProductDomain.ProductDomainReducer()
    }))
}
