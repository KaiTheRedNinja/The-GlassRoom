//
//  ContentView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 11/5/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var userModel: UserAuthModel = .shared

    var body: some View {
        if let isLoggedIn = userModel.isLoggedIn {
            if isLoggedIn {
                if userModel.hasNeededScopes() {
                    MainView()
                } else {
                    VStack {
                        Text("Still need some scopes!")
                        Button("Refresh") {
                            userModel.checkPermissions()
                        }
                    }
                    .padding()
                }
            } else {
                SignInView()
            }
        } else {
            ProgressView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
