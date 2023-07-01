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
        VStack {
            List(selection: $selection) {
                ForEach(coursesManager.courses) { course in
                    SidebarCourseView(course: .course(course.id))
                        .tag(GeneralCourse.course(course.id))
                }
            }
            .navigationTitle(UIScreen.main.traitCollection.userInterfaceIdiom == .pad ? "Glassroom" : "")
            .listStyle(.insetGrouped)
            .onAppear {
                coursesManager.loadList()
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
