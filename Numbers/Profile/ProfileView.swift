//
//  ProfileView.swift
//  Numbers
//
//  Created by Alonica🐦‍⬛🐺 on 29/02/24.
//

import SwiftUI
import ComposableArchitecture

struct ProfileView: View {
    let store : StoreOf<ProfileDomain.ProfileDomainReducer>
    
    var body: some View {
        NavigationView{
            ZStack{
                Form{
                    Section{
                        Text(store.profile.name)
                    } header: {
                        Text("Full Name")
                    }
                    Section{
                        Text(store.profile.email)
                    } header: {
                        Text("Email")
                    }
                }
                if store.loadingStatus == .loading{
                    ProgressView()
                }
            }
            .task{
                store.send(.loadProfile)
            }
            
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView(
        store:
            Store(
                initialState: ProfileDomain.ProfileDomainReducer.State(),
                reducer: {
                    ProfileDomain.ProfileDomainReducer(fetch: APIClient.liveApi.fetchProfile)
                })
    )
}
