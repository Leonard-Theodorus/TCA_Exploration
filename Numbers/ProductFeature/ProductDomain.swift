//
//  ProductDomain.swift
//  Numbers
//
//  Created by Alonica🐦‍⬛🐺 on 26/02/24.
//

import Foundation
import ComposableArchitecture

struct ProductDomain{
    @Reducer
    struct ProductDomainReducer{
        @ObservableState
        struct State : Equatable, Identifiable{
            let id : UUID
            let product : Product
            //MARK: Composition
            var addToCartState = AddToCartDomain.PlusMinusReducer.State()
            
            var count : Int{
                get {addToCartState.counter}
                set {addToCartState.counter = newValue}
            }
        }
        enum Action : Equatable{
            //MARK: Associated Type to work with all cases from AddToCartDomain
            case addToCart(AddToCartDomain.PlusMinusReducer.Action)
        }
        struct Environment{
            //MARK: Dependencies
        }
        
        var body : some ReducerOf<Self>{
            Scope(state: \.addToCartState, action: \.addToCart) {
                AddToCartDomain.PlusMinusReducer()
            }
            Reduce { state, action in
                switch action {
                    case .addToCart(.didTapPlus):
                        return .none
                    case .addToCart(.didTapMinus):
                        state.addToCartState.counter = max(0, state.addToCartState.counter)
                        return .none
                }
            }
        }
    }
}
