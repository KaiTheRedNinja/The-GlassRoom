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

            ToolbarItem(placement: .topBarTrailing) {
                if coursesManager.loading {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else {
                    Button {
                        coursesManager.loadList(bypassCache: true)
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .foregroundStyle(.blue)
                    }
                    .keyboardShortcut("r", modifiers: [.command, .shift])
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button("Load Only Cache") {
                            coursesManager.loadList(bypassCache: false)
                        }
                        Button("Reset Cache And Load") {
                            coursesManager.clearCache()
                            coursesManager.loadList(bypassCache: true)
                        }
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingSettingsView.toggle()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .foregroundStyle(.blue)
                }
                #if os(iOS)
                .keyboardShortcut(",", modifiers: .command)
                #endif
                .buttonStyle(.plain)
                .contextMenu {
                    if debugMode {
                        Button {
                            showingDebugView.toggle()
                        } label: {
                            Label("Debug View", systemImage: "exclamationmark.triangle.fill")
                        }
                        
                        Button {
                            showingAPICallsView.toggle()
                        } label: {
                            Label("API Calls View", systemImage: "arrow.left.arrow.right")
                        }
                    }
                }
                .padding(.leading, 5)
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
