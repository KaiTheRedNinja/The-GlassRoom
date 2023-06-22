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
    @AppStorage("useFancyUI") var useFancyUI: Bool = false

    @Environment(\.openWindow) var openWindow

    var body: some View {
        #if os(macOS)
        splitView
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
        #else
        TabView {
            splitView
                .sheet(isPresented: $showSearch) {
                    SearchView(selectedCourse: $selectedCourse,
                               selectedPost: $selectedPost)
                }
                .toolbar {
                    Button {
                        showSearch.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    .keyboardShortcut("O", modifiers: [.command, .shift])
                }
            if debugMode {
                DebugLogsView()
                    .tabItem {
                        Label("Logs", image: "exclamationmark.triangle.fill")
                    }

                DebugAPICallsView()
                    .tabItem {
                        Label("API Calls", image: "arrow.left.arrow.right")
                    }
            }

            SettingsView()
                .tabItem {
                    Label("Settings", image: "gearshape")
                }
        }
        #endif
    }

    @ViewBuilder
    var splitView: some View {
        #if os(macOS)
        if useFancyUI {
            NavigationSplitView {
                SidebarView(selection: $selectedCourse)
            } detail: {
                SplitView {
                    CenterSplitView(selectedCourse: $selectedCourse, selectedPost: $selectedPost)
                        .frame(minWidth: 250)
                } rView: {
                    ZStack {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                        DetailView(selectedCourse: $selectedCourse, selectedPost: $selectedPost)
                    }
                    .frame(minWidth: 200)
                    .cornerRadius(15)
                    .shadow(color: .primary.opacity(0.2), radius: 4)
                    .padding([.vertical, .trailing], 10)
                    .padding(.leading, 5)
                }
            }
        } else {
            traditionalView
        }
        #else
        traditionalView
        #endif
    }

    var traditionalView: some View {
        NavigationSplitView {
            SidebarView(selection: $selectedCourse)
        } content: {
            CenterSplitView(selectedCourse: $selectedCourse, selectedPost: $selectedPost)
                .frame(minWidth: 200)
        } detail: {
            DetailView(selectedCourse: $selectedCourse, selectedPost: $selectedPost)
                .frame(minWidth: 200)
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

#if os(iOS)
struct SidebarView: View { // TODO: Fix this
    @Binding var selection: GeneralCourse?

    var body: some View {
        Text("Not implemented yet")
    }
}
#endif

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
