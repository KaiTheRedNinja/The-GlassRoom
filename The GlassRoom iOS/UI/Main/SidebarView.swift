//
//  SidebarView.swift
//  The GlassRoom iOS
//
//  Created by Tristan Chay on 30/6/23.
//

import SwiftUI
import GlassRoomTypes

struct SidebarView: View { // TODO: Fix this
    
    @State var showingDebugView = false
    @State var showingAPICallsView = false
    @State var showingSettingsView = false
    
    @Binding var selection: GeneralCourse?
    
    @ObservedObject var coursesManager: GlobalCoursesDataManager = .global
    
    @AppStorage("debugMode") var debugMode: Bool = false
    
    var body: some View {
        SidebarListView(
            selection: $selection
        )
        .overlay {
            if coursesManager.courses.isEmpty {
                VStack {
                    Text("No Courses")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                }
            }
        }
        .toolbar {
            if UIScreen.main.traitCollection.userInterfaceIdiom == .phone {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Glassroom")
                        .font(.title3)
                        .fontWeight(.bold)
                }
            }

            ToolbarItem(placement: .primaryAction) {
                if coursesManager.loading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(.init(0.45))
                } else {
                    Button {
                        coursesManager.loadList(bypassCache: true)
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .contextMenu {
                        Button("Load Only Cache") {
                            coursesManager.loadList(bypassCache: false)
                        }
                        Button("Reset Cache And Load") {
                            coursesManager.clearCache()
                            coursesManager.loadList(bypassCache: true)
                        }
                    }
                    .offset(y: -1)
                }
            }

            ToolbarItem(placement: .navigation) {
                HStack {
                    if debugMode {
                        Button {
                            showingDebugView.toggle()
                        } label: {
                            Image(systemName: "exclamationmark.triangle.fill")
                        }
                        
                        Button {
                            showingAPICallsView.toggle()
                        } label: {
                            Image(systemName: "arrow.left.arrow.right")
                        }
                    }
                    
                    Button {
                        showingSettingsView.toggle()
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    #if os(iOS)
                    .keyboardShortcut(",", modifiers: [.command])
                    #endif
                }

            }
        }
        .sheet(isPresented: $showingDebugView) {
            DebugLogsView()
        }
        .sheet(isPresented: $showingAPICallsView) {
            DebugAPICallsView()
        }
        .sheet(isPresented: $showingSettingsView) {
            SettingsView()
        }
    }
}
