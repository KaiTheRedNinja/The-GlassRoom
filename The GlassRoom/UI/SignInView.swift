//
//  SignInView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 12/5/23.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var userModel: UserAuthModel = .shared

    @State var showSignInWithGoogle: Bool = false
    @State var showMoreScopes: Bool = false

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
            signInView
                .frame(width: 400, height: 300)
                .interactiveDismissDisabled(true)
        }
        .sheet(isPresented: $showMoreScopes) {
            addScopesView
                .frame(width: 400, height: 300)
                .interactiveDismissDisabled(true)
        }
        .onChange(of: userModel.isLoggedIn) { _ in
            checkState()
        }
        .onAppear {
            checkState()
        }
        .background(.thinMaterial)
    }

    func checkState() {
        if let isLoggedIn = userModel.isLoggedIn, isLoggedIn == true {
            DispatchQueue.main.async {
                showSignInWithGoogle = false
                showMoreScopes = true
            }
        } else {
            DispatchQueue.main.async {
                // we can assume that they need more scopes, since
                // if they didn't this screen would not be showing.
                showSignInWithGoogle = true
                showMoreScopes = true
            }
        }
    }

    var signInView: some View {
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
            .keyboardShortcut(.defaultAction)
            Spacer()
        }
    }

    var addScopesView: some View {
        VStack {
            Text("The GlassRoom requires the following permissions:")
                .multilineTextAlignment(.center)
                .font(.system(.title, design: .rounded))

            ScrollView(.vertical, showsIndicators: true) {
                ForEach(userModel.neededScopes, id: \.self) { scope in
                    HStack {
                        let isGranted = userModel.grantedScopes.contains(scope)
                        Image(systemName: isGranted ? "checkmark.circle.fill" : "circle")
                            .resizable().scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(isGranted ? .green : nil)
                        Text(scope.replacingOccurrences(of: "https://www.googleapis.com/auth/", with: ""))
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 25)
                }
            }

            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                Button("Sign Out") {
                    userModel.signOut()
                }
                .keyboardShortcut(.cancelAction)

                Button("Request Permissions") {
                    userModel.checkPermissions()
                }
                .buttonStyle(.borderedProminent)
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(20)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
