//
//  AddToCardButton.swift
//  Numbers
//
//  Created by Alonica🐦‍⬛🐺 on 26/02/24.
//

import SwiftUI
import ComposableArchitecture

struct AddToCardButton: View {
    let store : Store<AddToCartDomain.PlusMinusReducer.State, AddToCartDomain.PlusMinusReducer.Action>
    var body: some View {
        if store.counter > 0{
            PlusMinusButton(store: store)
        }
        else{
            Button{
                store.send(.didTapPlus)
            } label: {
                Text("Add to cart")
                    .padding(10)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    AddToCardButton(store: Store(initialState: AddToCartDomain.PlusMinusReducer.State(), reducer: {
        AddToCartDomain.PlusMinusReducer()
    }))
}
