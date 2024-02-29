//
//  RootDomainReducer.swift
//  Numbers
//
//  Created by Alonica🐦‍⬛🐺 on 29/02/24.
//

import Foundation
import ComposableArchitecture

struct RootDomain{
    @Reducer
    struct RootDomainReducer{
        enum Tab{
            case products
            case profile
        }
        
        @ObservableState
        struct State : Equatable{
            var selectedTab : Tab = .products
            var productsTabState = ProductListDomain.ProductListDomainReducer.State()
            var profileTabState = ProfileDomain.ProfileDomainReducer.State()
        }
        enum Action : Equatable{
            case tabSelected(Tab)
            case profile(ProfileDomain.ProfileDomainReducer.Action)
            case products(ProductListDomain.ProductListDomainReducer.Action)
        }
        
        var fetchProducts = APIClient.liveApi.fetchProducts
        var fetchProfile = APIClient.liveApi.fetchProfile
        
        
        var body : some ReducerOf<Self>{
            Scope(state: \.productsTabState, action: /Action.products) {
                ProductListDomain.ProductListDomainReducer(fetch: fetchProducts)
            }
            
            Scope(state: \.profileTabState, action: /Action.profile) {
                ProfileDomain.ProfileDomainReducer(fetch: fetchProfile)
            }
            
            Reduce { state, action in
                switch action{
                    case .tabSelected(let tab):
                        state.selectedTab = tab
                        return .none
                        
                    case .profile:
                        return .none
                    case .products:
                        return .none
                }
            }
        }
    }
}
