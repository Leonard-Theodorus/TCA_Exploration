//
//  ProducListDomain.swift
//  Numbers
//
//  Created by Alonica🐦‍⬛🐺 on 26/02/24.
//

import Foundation
import ComposableArchitecture

struct ProductListDomain{
    @Reducer
    struct ProductListDomainReducer{
        
        @ObservableState
        struct State : Equatable{
            var products : IdentifiedArrayOf<ProductDomain.ProductDomainReducer.State> = []
            var cartPresented = false
            var cartListState : CartListDomain.CartListDomainReducer.State?
            var loadingStatus : DataLoadingStatus = .notStarted
        }
        
        enum Action : Equatable{
            case loadProduct
            case fetchedProducts(TaskResult<[Product]>)
            case product(id: ProductDomain.ProductDomainReducer.State.ID, action: ProductDomain.ProductDomainReducer.Action)
            case openCart(presented : Bool)
            case cart(CartListDomain.CartListDomainReducer.Action)
        }
        
        var fetch : () async throws -> [Product]
        
        var body : some ReducerOf<Self>{
            
            Reduce { state, action in
                switch action{
                    case .loadProduct:
                        if state.loadingStatus == .loading || state.loadingStatus == .success{
                            return .none
                        }
                        state.loadingStatus = .loading
                        return .run { send in
                            await send(
                                .fetchedProducts(
                                    TaskResult{
                                        try await fetch()
                                    }
                                )
                            )
                        }
                    case .fetchedProducts(.success(let product)):
                        state.products = IdentifiedArray(
                            uniqueElements: product.map{
                                ProductDomain.ProductDomainReducer.State(id: UUID(), product: $0)
                            }
                        )
                        state.loadingStatus = .success
                        return .none
                    case .fetchedProducts(.failure(let error)):
                        print(error.localizedDescription)
                        state.loadingStatus = .error
                        return .none
                        
                    case .product:
                        return .none
                    case .cart(let action):
                        switch action{
                            case .closeCart:
                                state.cartPresented = false
                            case .cartItem(_, let action):
                                switch action{
                                    case .deleteCartItem(let product):
                                        guard let index = state.products.firstIndex(
                                            where: { $0.product == product}
                                        )
                                        else { return .none }
                                        state.products[index].count = 0
                                }
                            case .purchaseAlert(.presented(.confirmPurchase)):
                                for id in state.products.map(\.id){
                                    state.products[id : id]?.count = 0
                                }
                                return .none
                            case .successAlert(_):
                                state.cartPresented = false
                                return .none
                            default:
                                break
                        }
                        return .none
                        
                    case .openCart(let presented):
                        state.cartPresented = presented
                        state.cartListState = presented
                        ? CartListDomain.CartListDomainReducer.State(
                            cartListItems: IdentifiedArray(uniqueElements: state.products.compactMap{
                                $0.count > 0
                                ?
                                CartItemDomain.CartItemDomainReducer.State(
                                    id: UUID(), cartItem: CartItem(id: UUID(), product: $0.product, quantity: $0.count)
                                )
                                :
                                nil
                            })
                        )
                        : nil
                        return .none
                }
            }
            .ifLet(\.cartListState, action: \.cart){
                CartListDomain.CartListDomainReducer()
            }
            .forEach(\.products, action: /Action.product(id:action:)){
                ProductDomain.ProductDomainReducer()
            }
            ._printChanges()
        }
    }
}
