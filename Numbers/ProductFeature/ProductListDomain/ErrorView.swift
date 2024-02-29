//
//  ErrorView.swift
//  Numbers
//
//  Created by Alonica🐦‍⬛🐺 on 29/02/24.
//

import SwiftUI

struct ErrorView: View {
    let message : String
    let retryAction : () -> Void
    var body: some View {
        VStack{
            Text(":(")
                .font(.largeTitle)
            Text(message)
                .font(.title)
            Button{
                retryAction()
            } label: {
                Text("Retry")
                    .font(.title3)
                    .frame(width: 100, height: 30)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                    .buttonStyle(.plain)
                    .padding()
            }
        }
    }
}

#Preview {
    ErrorView(message: "Can't load items, please retry", retryAction: {
        
    })
}
