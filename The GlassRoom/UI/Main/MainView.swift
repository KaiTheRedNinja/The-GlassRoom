//
//  MainView.swift
//  The GlassRoom
//
//  Created by Tristan on 11/05/2023.
//

import SwiftUI
import GlassRoomAPI

struct MainView: View {
    @State var selectedCourse: GeneralCourse?
    @State var selectedPost: CoursePost?
    @State var showSearch: Bool = false

    @ObservedObject var userModel: UserAuthModel = .shared

    @State var showApiCalls: Bool = false
    @State var showLogs: Bool = false

    @AppStorage("debugMode") var debugMode: Bool = false

    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $selectedCourse)
        } content: {
            CenterSplitView(selectedCourse: $selectedCourse, selectedPost: $selectedPost)
                .frame(minWidth: 200)
        } detail: {
            DetailView(selectedCourse: $selectedCourse, selectedPost: $selectedPost)
                .frame(minWidth: 400)
        }
        .sheet(isPresented: $showSearch) {
            SearchView(selectedCourse: $selectedCourse,
                       selectedPost: $selectedPost)
        }
        .toolbar {
            if debugMode {
                Button {
                    showLogs.toggle()
                } label: {
                    Image(systemName: "exclamationmark.triangle.fill")
                }
                .popover(isPresented: $showLogs) {
                    DebugLogsView()
                }

                Button {
                    showApiCalls.toggle()
                } label: {
                    Image(systemName: "arrow.left.arrow.right")
                }
                .popover(isPresented: $showApiCalls) {
                    DebugAPICallsView()
                }
            }

            Button {
                showSearch.toggle()
            } label: {
                Image(systemName: "magnifyingglass")
            }
            .keyboardShortcut("O", modifiers: [.command, .shift])
            
            Button {
                NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
            } label: {
                Image(systemName: "gearshape")
            }
        }
        .onAppear {
            loadCachedStreams()
        }
    }

    func loadCachedStreams() {
        let coursesManager = GlobalCoursesDataManager.global
        if coursesManager.courses.isEmpty {
            coursesManager.loadList()
        }
        let courses = coursesManager.courses
        for course in courses {
            let manager = CoursePostsDataManager.getManager(for: course.id)
            DispatchQueue.main.async {
                manager.loadList(onlyCache: true)
            }
        }
        Log.info("Loaded managers: \(CoursePostsDataManager.loadedManagers.keys)")
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
