//
//  SignInView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 12/5/23.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var userModel: UserAuthModel = .shared

    @State var showSignInWithGoogle: Bool = true

    var body: some View {
        VStack {
            Spacer()
            if let errorMsg = userModel.errorMessage {
                Text(errorMsg)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showSignInWithGoogle) {
            VStack {
                Spacer()
                Image(systemName: "app") // TODO: Replace with app icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                Spacer()
                Text("Welcome to The GlassRoom")
                    .font(.system(.largeTitle, design: .rounded))
                Spacer()
                if userModel.errorMessage?.contains("connection appears to be offline") ?? false {
                    Text("""
You seem to be offline. The GlassRoom
requires an internet connection to work.
""")
                    .multilineTextAlignment(.center)
                    Spacer()
                }
                Button {
                    userModel.signIn()
                } label: {
                    Text("Sign in with Google")
                }
                Spacer()
            }
            .frame(width: 400, height: 300)
            .interactiveDismissDisabled(true)
        }
        .background(.thinMaterial)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
