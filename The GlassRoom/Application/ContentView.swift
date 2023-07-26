//
//  ContentView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 11/5/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var userModel: UserAuthModel = .shared
    @StateObject var windowAccessor = WindowAccessor()

    var body: some View {
        if let isLoggedIn = userModel.isLoggedIn {
            if (isLoggedIn && userModel.hasNeededScopes()) || (!isLoggedIn && userModel.email != nil) {
                MainView()
                    .environmentObject(windowAccessor)
                    .background {
                        WindowAccessorView(window: $windowAccessor.window)
                    }
            } else {
                SignInView()
            }
        } else {
            ProgressView()
        }
    }
}

struct WindowAccessorView: NSViewRepresentable {
    @Binding var window: NSWindow?

    func makeNSView(context: Context) -> NSView {
        return NSView()
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        DispatchQueue.main.async {
            self.window = nsView.window
        }
    }
    
    typealias NSViewType = NSView
}

class WindowAccessor: ObservableObject {
    @Published var window: NSWindow?

    init(window: NSWindow? = nil) {
        self.window = window
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
