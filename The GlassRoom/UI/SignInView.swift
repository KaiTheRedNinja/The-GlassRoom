//
//  SignInView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 12/5/23.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var userModel: UserAuthModel = .shared

    var body: some View {
        List {
            Button {
                userModel.signIn()
            } label: {
                Text("Sign in with Google")
                    .frame(maxWidth: .infinity)
            }
            if let errorMsg = userModel.errorMessage {
                Text(errorMsg)
            }
        }
        .navigationTitle("Login")
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
