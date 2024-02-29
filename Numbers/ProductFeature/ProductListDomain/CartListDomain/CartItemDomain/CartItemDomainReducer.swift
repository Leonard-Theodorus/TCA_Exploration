//
//  CartItemDomainReducer.swift
//  Numbers
//
//  Created by Alonica🐦‍⬛🐺 on 27/02/24.
//

import Foundation
import ComposableArchitecture

struct CartItemDomain{
    @Reducer
    struct CartItemDomainReducer{
        
        @ObservableState
        struct State : Equatable, Identifiable{
            let id : UUID
            let cartItem : CartItem
        }
        
        enum Action : Equatable {
            case deleteCartItem(product : Product)
        }
        
        var body : some ReducerOf<Self>{
            
            Reduce { state, action in
                switch action{
                    case .deleteCartItem:
                        return .none
                }
            }
        }
    }
    
}
