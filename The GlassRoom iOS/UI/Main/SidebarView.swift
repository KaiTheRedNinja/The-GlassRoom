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
            .listStyle(.grouped)
            .onAppear {
                coursesManager.loadList()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("Glassroom")
                    .font(.title3)
                    .fontWeight(.bold)
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
