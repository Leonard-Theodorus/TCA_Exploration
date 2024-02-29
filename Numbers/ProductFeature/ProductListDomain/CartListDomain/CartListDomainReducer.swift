//
//  CartListDomainReducer.swift
//  Numbers
//
//  Created by Alonica🐦‍⬛🐺 on 27/02/24.
//

import Foundation
import ComposableArchitecture

struct CartListDomain{
    @Reducer
    struct CartListDomainReducer{
        
        @ObservableState
        struct State : Equatable{
            var cartListItems : IdentifiedArrayOf<CartItemDomain.CartItemDomainReducer.State> = []
            var totalPrice : Int = 0
            var totalButtonDisabled : Bool = false
            var loadingStatus : DataLoadingStatus = .notStarted
            @Presents var purchaseAlertState : AlertState<Action.PurchaseAlert>?
            @Presents var successAlertState : AlertState<Action.SuccessAlert>?
            @Presents var errorAlertState : AlertState<Action.ErrorAlert>?
        }
        
        enum Action : Equatable{
            case closeCart
            case cartItem(id: CartItemDomain.CartItemDomainReducer.State.ID, action: CartItemDomain.CartItemDomainReducer.Action)
            case getTotalPrice
            case didTapPayButton
            case didReceivePurchaseReport(TaskResult<String>)
            case purchaseAlert(PresentationAction<PurchaseAlert>)
            case successAlert(PresentationAction<SuccessAlert>)
            case errorAlert(PresentationAction<ErrorAlert>)
            case didConfirmPurchase
            case didCancelPurchase
            
            enum PurchaseAlert : Equatable{
                case confirmPurchase
                case cancelPurchase
            }
            
            enum SuccessAlert: Equatable{
                case purchaseSuccess
            }
            
            enum ErrorAlert : Equatable{
                case purchaseError
            }
        }
        private var sendOrder : ([CartItem]) async throws -> String = APIClient.liveApi.sendOrder
        
        var body : some ReducerOf<Self>{
            Reduce { state, action in
                switch action{
                    case .closeCart:
                        return .none
                        
                    case .cartItem(let id, let action):
                        switch action{
                            case .deleteCartItem:
                                state.cartListItems.remove(id: id)
                                return .send(.getTotalPrice)
                        }
                    case .getTotalPrice:
                        state.totalPrice = state.cartListItems.map { $0.cartItem}
                            .reduce(0, {$0 + ($1.quantity * Int($1.product.price))})
                        return CartListDomainReducer.shouldDisablePayButton(state: &state)
                        
                    case .didTapPayButton:
                        state.purchaseAlertState = AlertState(
                            title: TextState("Confirm Your Purchase"),
                            message: TextState("Proceed with this purchase?"),
                            buttons: [
                                .default(TextState("Pay $\(state.totalPrice.description)"), action: .send(.confirmPurchase)),
                                .cancel(TextState("Cancel"), action: .send(.cancelPurchase))
                            ])
                        return .none
                        
                    case .didReceivePurchaseReport(.success(let message)):
                        print(message)
                        state.loadingStatus = .success
                        state.successAlertState = AlertState(
                            title: TextState("Purchase Successful!"),
                            buttons: [
                                .default(TextState(message))
                            ]
                        )
                        return .none
                    case .didReceivePurchaseReport(.failure(let error)):
                        print(error)
                        state.loadingStatus = .error
                        state.errorAlertState = AlertState(
                            title: TextState("Purchase Unsucessful!"),
                            buttons: [
                                .default(TextState(error.localizedDescription))
                            ]
                            
                        )
                        return .none
                    case .didConfirmPurchase:
                        state.loadingStatus = .loading
                        state.successAlertState = AlertState(
                            title: TextState("Purchase Successful!"),
                            buttons: [
                                .default(TextState("Continue"))
                            ]
                        )
                        let items = state.cartListItems.map { $0.cartItem }
                        return .run{ send in
                            await send(
                                .didReceivePurchaseReport(
                                    TaskResult{
                                        try await sendOrder(items)
                                    }
                                )
                            )
                        }
                    case .didCancelPurchase:
                        state.purchaseAlertState = nil
                        return .none
                        
                    case .purchaseAlert(let action):
                        switch action{
                            case .presented(.confirmPurchase):
                                return .send(CartListDomainReducer.Action.didConfirmPurchase)
                            case .presented(.cancelPurchase):
                                state.purchaseAlertState = nil
                                return .none
                            case .dismiss:
                                state.purchaseAlertState = nil
                                return .none
                        }
                    case .successAlert(_):
                        state.successAlertState = nil
                        return .none
                    case .errorAlert(_):
                        state.errorAlertState = nil
                        return .none
                        
                }
            }
            .forEach(\.cartListItems, action: /Action.cartItem){
                CartItemDomain.CartItemDomainReducer()
            }
        }
        private static func shouldDisablePayButton(state : inout State) -> Effect<Action>{
            state.totalButtonDisabled = state.totalPrice == 0
            return .none
        }
    }
    
}
