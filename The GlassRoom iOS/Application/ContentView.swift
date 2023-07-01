//
//  ContentView.swift
//  The GlassRoom iOS
//
//  Created by Kai Quan Tay on 22/6/23.
//

import SwiftUI

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
            ProgressView()
        }
    }
}

//#Preview {
//    ContentView()
//}
