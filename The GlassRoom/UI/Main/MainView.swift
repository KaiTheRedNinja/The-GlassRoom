//
//  MainView.swift
//  The GlassRoom
//
//  Created by Tristan on 11/05/2023.
//

import SwiftUI
import GlassRoomTypes

struct MainView: View {
    @State var selectedCourse: GeneralCourse?
    @State var selectedPost: CoursePost?
    @State var showSearch: Bool = false

    @ObservedObject var userModel: UserAuthModel = .shared
    @AppStorage("debugMode") var debugMode: Bool = false
    @Environment(\.openWindow) var openWindow

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
                    openWindow(id: "debugLogsView")
                } label: {
                    Image(systemName: "exclamationmark.triangle.fill")
                }

                Button {
                    openWindow(id: "debugAPICallsView")
                } label: {
                    Image(systemName: "arrow.left.arrow.right")
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
        let archived = coursesManager.configuration.archive?.courses ?? []
        if coursesManager.courses.isEmpty {
            coursesManager.loadList()
        }
        let courses = coursesManager.courses
        for course in courses where !archived.contains(course.id) {
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
