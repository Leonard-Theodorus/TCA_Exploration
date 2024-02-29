//
//  AddToCartDomain.swift
//  Numbers
//
//  Created by Alonica🐦‍⬛🐺 on 26/02/24.
//

import Foundation
import ComposableArchitecture

struct AddToCartDomain{
    
    @Reducer
    struct PlusMinusReducer{
        @ObservableState
        struct State : Equatable{
            var counter = 0
        }
        
        enum Action : Equatable{
            case didTapPlus
            case didTapMinus
        }
        
        struct Environment{
            //MARK: Later Dependencies if needed
        }
        
        var body : some ReducerOf<Self>{
            Reduce { state, action in
                switch action{
                    case .didTapPlus:
                        state.counter += 1
                        return Effect.none
                    case .didTapMinus:
                        state.counter -= 1
                        return Effect.none
                }
            }
        }
    }
}
