//
//  The_GlassRoomApp.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 11/5/23.
//

import SwiftUI

@main
struct The_GlassRoomApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .focusable(false)
        }

        WindowGroup(id: "debugLogsView") {
            DebugLogsView()
                .navigationTitle("Logs")
        }

        WindowGroup(id: "debugAPICallsView") {
            DebugAPICallsView()
                .navigationTitle("API Calls")
        }

        Settings {
            SettingsView()
                .focusable(false)
        }
    }
}
