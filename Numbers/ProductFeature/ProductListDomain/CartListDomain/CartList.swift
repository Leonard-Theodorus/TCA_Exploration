//
//  CartList.swift
//  Numbers
//
//  Created by Alonica🐦‍⬛🐺 on 27/02/24.
//

import SwiftUI
import ComposableArchitecture

struct CartList: View {
    @Bindable var store : StoreOf<CartListDomain.CartListDomainReducer>
    
    var body: some View {
        ZStack{
            NavigationStack{
                Group{
                    if store.cartListItems.isEmpty{
                        Text("Oops, your cart is empty!")
                            .font(.title)
                    }
                    else{
                        List{
                            ForEachStore(store.scope(state: \.cartListItems, action: \.cartItem)) { store in
                                CartItemCell(store: store)
                            }
                        }
                        
                        .safeAreaInset(edge: .bottom) {
                            Button{
                                store.send(.didTapPayButton)
                            } label: {
                                HStack(alignment: .center){
                                    Spacer()
                                    Text("$\(store.totalPrice.description)")
                                        .font(.title2)
                                        .foregroundStyle(.white)
                                    Spacer()
                                    
                                }
                            }
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(
                                        store.totalButtonDisabled ? .gray : .blue
                                        
                                    )
                            )
                            .padding()
                            .disabled(store.totalButtonDisabled)
                            .alert(store: store.scope(state: \.$purchaseAlertState, action: \.purchaseAlert))
                            .alert(store: store.scope(state: \.$successAlertState, action: \.successAlert))
                            .alert(store: store.scope(state: \.$errorAlertState, action: \.errorAlert))
                        }
                    }
                }
                .onAppear{
                    store.send(.getTotalPrice)
                }
                .navigationTitle("Cart")
                .toolbar{
                    ToolbarItem(placement: .topBarLeading) {
                        Button{
                            store.send(.closeCart)
                        } label: {
                            Text("Close Cart")
                        }
                    }
                }
            }
            
            if store.loadingStatus == .loading{
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
                ProgressView()
            }
        }
    }
}

#Preview {
    CartList(
        store: (
            Store(
                initialState: CartListDomain.CartListDomainReducer.State(
                    cartListItems:
                        IdentifiedArray(uniqueElements: CartItem.mock.map{
                            CartItemDomain.CartItemDomainReducer.State(
                                id: $0.id,
                                cartItem: $0
                            )
                        })
                ),
                reducer: {
                    CartListDomain.CartListDomainReducer()
                }
            )
        )
    )
}
