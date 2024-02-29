//
//  RootView.swift
//  Numbers
//
//  Created by Alonica🐦‍⬛🐺 on 29/02/24.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    @Bindable var store : StoreOf<RootDomain.RootDomainReducer>
    
    var body: some View {
        TabView(selection: $store.selectedTab.sending(\.tabSelected)){
            
            ProductList(store: store.scope(state: \.productsTabState, action: \.products))
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Products")
                }
                .tag(RootDomain.RootDomainReducer.Tab.products)
            
            ProfileView(store: store.scope(state: \.profileTabState, action: \.profile))
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(RootDomain.RootDomainReducer.Tab.profile)
        }
    }
}

#Preview {
    RootView(
        store: (
            Store(initialState: RootDomain.RootDomainReducer.State(), reducer: {
                RootDomain.RootDomainReducer()
            })
        )
    )
}
