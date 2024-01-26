//
//  The_GlassRoomApp.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 11/5/23.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        let mainWindow = NSApp.windows.first
        mainWindow?.delegate = self
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        let mainWindow = NSApp.windows.first
        if flag {
            mainWindow?.orderFront(nil)
        } else {
            mainWindow?.makeKeyAndOrderFront(nil)
        }
        return true
    }
}

@main
struct The_GlassRoomApp: App {
    
    @ObservedObject var windowAccessor = WindowAccessor()
    @EnvironmentObject var window: WindowAccessor
    
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

