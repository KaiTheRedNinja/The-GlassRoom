//
//  ContentView.swift
//  Glassroom‌
//
//  Created by Tristan Chay on 17/12/25.
//

import SwiftUI
import AuthenticationServices

struct ContentView: View {
    @ObservedObject var userModel: UserAuthModel = .shared

    var body: some View {
        if let isLoggedIn = userModel.isLoggedIn {
            if (isLoggedIn && userModel.hasNeededScopes()) || (!isLoggedIn && userModel.email != nil) {
                MainView()
            } else {
                SignInView()
            }
        } else {
            ProgressView("Loading...")
                .controlSize(.large)
        }
    }
}
