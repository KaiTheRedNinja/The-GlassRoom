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
        #if os(macOS)
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
        #else
        ZStack {
            if showMoreScopes {
                addScopesView
            }
            if showSignInWithGoogle {
                signInView
                    .padding(.horizontal, 5)
            }
        }
        .padding(20)
        .onChange(of: userModel.isLoggedIn) { _ in
            checkState()
        }
        .onAppear {
            checkState()
        }
        #endif
    }

    func checkState() {
        if let isLoggedIn = userModel.isLoggedIn, isLoggedIn == true {
            DispatchQueue.main.async {
                showSignInWithGoogle = false
                showMoreScopes = true
            }
        } else {
            DispatchQueue.main.async {
                if !(userModel.isLoggedIn ?? false) {
                    showSignInWithGoogle = true
                    showMoreScopes = false
                } else {
                    if !userModel.hasNeededScopes() {
                        showMoreScopes = true
                    } else {
                        showMoreScopes = false
                    }
                }
            }
        }
    }

    var signInView: some View {
        VStack {
            Spacer()
            #if os(iOS)
            Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .mask(Image(systemName: "app.fill").resizable().scaledToFit().frame(width: 100, height: 100))
                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.50), radius: 5, x: 0, y: 0)
            #else
            Image(nsImage: NSImage(named: "AppIcon") ?? NSImage())
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            #endif
            
            #if os(macOS)
            Spacer()
            #endif
            
            Text("Welcome to The Glassroom")
                .font(.system(.largeTitle, weight: .bold))
                .multilineTextAlignment(.center)
            
            #if os(macOS)
            Spacer()
            #endif
            
            if userModel.errorMessage?.contains("connection appears to be offline") ?? false {
                Text("""
You seem to be offline. The Glassroom
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
            #if os(iOS)
            .buttonStyle(.borderedProminent)
            .padding(.vertical)
            #endif
            
            Spacer()
            
            #if os(iOS)
            if let errorMsg = userModel.errorMessage {
                Text(errorMsg)
                    .multilineTextAlignment(.center)
                    .font(.system(.caption, weight: .bold))
                    .foregroundStyle(.secondary)
                    .padding(.bottom)
            }
            #endif
        }
    }

    var addScopesView: some View {
        VStack {
            Text("The Glassroom requires the following permissions:")
                .multilineTextAlignment(.center)
                .font(.system(.title, weight: .bold))

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
                #if os(macOS)
                Spacer()
                #endif
                
                Button("Sign Out") {
                    userModel.signOut()
                }
                .keyboardShortcut(.cancelAction)
                #if os(iOS)
                .buttonStyle(.bordered)
                #endif
                
                #if os(iOS)
                Spacer()
                #endif

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
