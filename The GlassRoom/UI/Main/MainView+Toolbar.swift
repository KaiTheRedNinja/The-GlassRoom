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
                    Image(systemName: "exclamationmark.triangle.fill")
                }
            }

            ToolbarItem {
                Button {
                    openWindow(id: "debugAPICallsView")
                } label: {
                    Image(systemName: "arrow.left.arrow.right")
                }
            }
        }

        ToolbarItem {
            GroupBox {
                ZStack {
                    HStack {
                        Button {
                            guard let window = window.window else { return }
                            window.toggleTabBar(self)
                        } label: {
                            Image(systemName: "rectangle.topthird.inset.filled")
                        }
                        //                        .onKeyboardShortcut(.toggleTabBar, type: .keyDown) {
                        //                            guard let window = window.window else { return }
                        //                            window.toggleTabBar(self)
                        //                        }
                        .keyboardShortcut("b", modifiers: [.command, .shift])
                        .help("Toggle Tab Bar (⌘⇧B)")

                        Button {
                            guard let window = window.window else { return }
                            window.toggleTabOverview(self)
                        } label: {
                            Image(systemName: "square.grid.2x2")
                        }
                    }
                    //                    .onKeyboardShortcut(.nextTab, type: .keyDown) {
                    //                        guard let window = window.window else { return }
                    //                        window.selectNextTab(self)
                    //                        print("ive been called (next)")
                    //                    }
                    //                    .onKeyboardShortcut(.previousTab, type: .keyDown) {
                    //                        guard let window = window.window else { return }
                    //                        window.selectPreviousTab(nil)
                    //                        print("ive been called (prev)")
                    //                    }
                }
            }
        }

        ToolbarItem {
            Button {
                showSearch.toggle()
            } label: {
                Image(systemName: "magnifyingglass")
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
                    Image(systemName: "gearshape")
                }
            } else {
                Button {
                    NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
    }
}
