//
//  NumbersApp.swift
//  Numbers
//
//  Created by Alonica🐦‍⬛🐺 on 26/02/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct NumbersApp: App {
    let store = Store(initialState: RootDomain.RootDomainReducer.State()) {
        RootDomain.RootDomainReducer()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(store: store)
        }
    }
}
