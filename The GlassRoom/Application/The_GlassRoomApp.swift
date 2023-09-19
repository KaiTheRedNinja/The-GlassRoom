//
//  The_GlassRoomApp.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 11/5/23.
//

import SwiftUI
#if os(macOS)
import KeyboardShortcuts
#endif

@main
struct The_GlassRoomApp: App {
    
    @ObservedObject var windowAccessor = WindowAccessor()
    @EnvironmentObject var window: WindowAccessor
    @StateObject private var appState = AppState()
    
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

        WindowGroup(id: "notesView") {
            NotesView()
        }

        Settings {
            SettingsView()
                .focusable(false)
        }
    }
}

@MainActor
final class AppState: ObservableObject {
    func createMenus() {
        let testMenuItem = NSMenuItem()
        NSApp.mainMenu?.addItem(testMenuItem)

        let testMenu = NSMenu()
        testMenu.title = "Test"
        testMenuItem.submenu = testMenu

        testMenu.addCallbackItem("Open Universal Search") { [weak self] in
            self?.alert(1)
        }
        .setShortcut(for: .openUniversalSearch)
        
        testMenu.addCallbackItem("Next Tab") { [weak self] in
            self?.alert(2)
        }
        .setShortcut(for: .nextTab)
        
        testMenu.addCallbackItem("Previous Tab") { [weak self] in
            self?.alert(3)
        }
        .setShortcut(for: .previousTab)
        
        testMenu.addCallbackItem("Reload Sidebar") { [weak self] in
            self?.alert(4)
        }
        .setShortcut(for: .reloadSidebar)
        
        testMenu.addCallbackItem("Reload Posts") { [weak self] in
            self?.alert(5)
        }
        .setShortcut(for: .reloadCoursePosts)
        
        testMenu.addCallbackItem("Toggle Tab Bar") { [weak self] in
            self?.alert(6)
        }
        .setShortcut(for: .toggleTabBar)
    }

    private func alert(_ number: Int) {
        print("Shortcut \(number) menu item action triggered!")
    }
}

