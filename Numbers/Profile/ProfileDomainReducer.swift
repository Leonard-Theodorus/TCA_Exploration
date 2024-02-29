//
//  ProfileDomainReducer.swift
//  Numbers
//
//  Created by Alonica🐦‍⬛🐺 on 29/02/24.
//

import Foundation
import ComposableArchitecture

struct ProfileDomain{
    @Reducer
    struct ProfileDomainReducer{
        
        @ObservableState
        struct State : Equatable{
            var profile : Profile = Profile.mock
            var loadingStatus : DataLoadingStatus = .notStarted
        }
        
        enum Action : Equatable{
            case loadProfile
            case fetchedProfile(TaskResult<Profile>)
        }
        
        var fetch : () async throws -> Profile
        
        var body : some ReducerOf<Self>{
            Reduce { state, action in
                switch action{
                    case .loadProfile:
                        if state.loadingStatus == .loading || state.loadingStatus == .success{
                            return .none
                        }
                        state.loadingStatus = .loading
                        return .run { send in
                            await send(.fetchedProfile(
                                TaskResult { try await fetch() } )
                            )
                        }
                    case .fetchedProfile(.success(let profile)):
                        state.loadingStatus = .success
                        state.profile = profile
                        return .none
                    case .fetchedProfile(.failure(let error)):
                        print(error.localizedDescription)
                        state.loadingStatus = .error
                        return .none
                }
            }
        }
    }
}
