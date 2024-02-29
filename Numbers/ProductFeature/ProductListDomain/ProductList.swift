//
//  ProductList.swift
//  Numbers
//
//  Created by Alonica🐦‍⬛🐺 on 26/02/24.
//

import SwiftUI
import ComposableArchitecture

struct ProductList: View {
    @Bindable var store : StoreOf<ProductListDomain.ProductListDomainReducer>
    var body: some View {
        NavigationStack {
            Group{
                if store.loadingStatus == .loading{
                    ProgressView()
                        .frame(width: 200, height: 200)
                }
                else if store.loadingStatus == .error{
                    ErrorView(message: "Can't load items, pleae rery") {
                        store.send(.loadProduct)
                    }
                }
                else{
                    List{
                        ForEachStore(self.store.scope(state: \.products, action: \.product)){ store in
                            ProductCell(store: store)
                        }
                    }
                }
            }
            .task{
                store.send(ProductListDomain.ProductListDomainReducer.Action.loadProduct)
            }
            .navigationTitle("Products")
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        store.send(.openCart(presented: true))
                    } label: {
                        Text("Open Cart")
                    }
                }
            }
            .sheet(isPresented: $store.cartPresented.sending(\.openCart), content: {
                IfLetStore(store.scope(state: \.cartListState, action: \.cart)) { store in
                    CartList(store: store)
                }
                
            })
        }
    }
}

#Preview {
    ProductList(
        store : Store (
            initialState: ProductListDomain.ProductListDomainReducer.State(), reducer: {
                ProductListDomain.ProductListDomainReducer(fetch: {return Product.mock})
            }
        )
    )
}
