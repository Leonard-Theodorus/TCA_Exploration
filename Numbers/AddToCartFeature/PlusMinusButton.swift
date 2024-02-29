//
//  PlusMinusButton.swift
//  Numbers
//
//  Created by Alonica🐦‍⬛🐺 on 26/02/24.
//

import SwiftUI
import ComposableArchitecture

struct PlusMinusButton: View {
    let store : Store<AddToCartDomain.PlusMinusReducer.State, AddToCartDomain.PlusMinusReducer.Action>
    var body: some View {
        HStack {
            Button{
                store.send(.didTapMinus)
            } label: {
                Text("-")
                    .padding(10)
                    .background(Color.black.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
            
            Text(store.counter.description)
                .padding(5)
            
            Button{
                store.send(.didTapPlus)
            } label: {
                Text("+")
                    .padding(10)
                    .background(Color.black.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    PlusMinusButton(store: Store(initialState: AddToCartDomain.PlusMinusReducer.State(), reducer: {
        AddToCartDomain.PlusMinusReducer()
    }))
}
