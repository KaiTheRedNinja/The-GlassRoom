//
//  MainView+Toolbar.swift
//  Glassroom
//
//  Created by Kai Quan Tay on 19/1/24.
//

import SwiftUI

extension MainView {
    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            BreadcrumbsView(selectedCourse: $selectedCourse, selectedPost: $selectedPost)
        }

        if debugMode {
            ToolbarItem {
                Button {
                    openWindow(id: "debugLogsView")
                } label: {
                    Label("Logs", systemImage: "exclamationmark.triangle.fill")
                }
            }

            ToolbarItem {
                Button {
                    openWindow(id: "debugAPICallsView")
                } label: {
                    Label("API Calls", systemImage: "arrow.left.arrow.right")
                }
            }
        }

        ToolbarItem {
                    Button {
                        guard let window = window.window else { return }
                        window.toggleTabBar(self)
                    } label: {
                        Label("Tab Bar", systemImage: "rectangle.topthird.inset.filled")
                    }
                    //                        .onKeyboardShortcut(.toggleTabBar, type: .keyDown) {
                    //                            guard let window = window.window else { return }
                    //                            window.toggleTabBar(self)
                    //                        }
                    .keyboardShortcut("b", modifiers: [.command, .shift])
                    .help("Toggle Tab Bar (⌘⇧B)")
        }
        
        ToolbarItem {
            Button {
                guard let window = window.window else { return }
                window.toggleTabOverview(self)
            } label: {
                Label("Tabs View", systemImage: "square.grid.2x2")
            }
            .keyboardShortcut("\\", modifiers: [.command, .shift])
            .help("Toggle Tabs View (⌘⇧\\)")
        }

        ToolbarItem {
            Button {
                showSearch.toggle()
            } label: {
                Label("Universal Search", systemImage: "magnifyingglass")
            }
            //            .onKeyboardShortcut(.openUniversalSearch, type: .keyDown) {
            //                showSearch.toggle()
            //            }
            .keyboardShortcut("o", modifiers: [.command, .shift])
            .help("Universal Search (⌘⇧O)")
        }

        ToolbarItem {
            if #available(macOS 14.0, *) {
                SettingsLink {
                    Label("Settings", systemImage: "gearshape")
                }
                .keyboardShortcut(",", modifiers: [.command])
                .help("Settings (⌘,)")
            } else {
                Button {
                    NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                } label: {
                    Label("Settings", systemImage: "gearshape")
                }
                .keyboardShortcut(",", modifiers: [.command])
                .help("Settings (⌘,)")
            }
        }
    }
}
