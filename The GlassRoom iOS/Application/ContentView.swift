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
            VStack {
                Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .mask(Image(systemName: "app.fill").resizable().scaledToFit().frame(width: 100, height: 100))
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.50), radius: 5, x: 0, y: 0)
                ProgressView("Loading...")
                    .controlSize(.regular)
                    .padding(.top, 10)
            }
        }
    }
}

//#Preview {
//    ContentView()
//}
