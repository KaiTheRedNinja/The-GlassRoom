//
//  MainView.swift
//  The GlassRoom
//
//  Created by Tristan on 11/05/2023.
//

import SwiftUI
import GlassRoomTypes
import KeyboardShortcuts

struct MainView: View {
    @State var selectedCourse: GeneralCourse?
    @State var selectedPost: CoursePost?
    @State var showSearch: Bool = false
    
    @State var columnVisibility = NavigationSplitViewVisibility.all

    @ObservedObject var userModel: UserAuthModel = .shared
    @AppStorage("debugMode") var debugMode: Bool = false
    @AppStorage("useFancyUI") var useFancyUI: Bool = false
    
    @Environment(\.openWindow) var openWindow

    #if os(macOS)
    @EnvironmentObject var window: WindowAccessor
    #endif

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

            GroupBox {
                ZStack {
                    HStack {
                        Button {
                            guard let window = window.window else { return }
                            window.toggleTabBar(self)
                        } label: {
                            Image(systemName: "rectangle.topthird.inset.filled")
                        }
                        .onKeyboardShortcut(.toggleTabBar, type: .keyDown) {
                            guard let window = window.window else { return }
                            window.toggleTabBar(self)
                        }
                        
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

            Button {
                showSearch.toggle()
            } label: {
                Image(systemName: "magnifyingglass")
            }
            .onKeyboardShortcut(.openUniversalSearch, type: .keyDown) {
                showSearch.toggle()
            }

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
        .onAppear {
            loadCachedStreams()
        }
        .navigationTitle(title)
        #else
        splitView
        #endif
    }

    var title: String {
        var value = ""
        if let selectedPost {
            switch selectedPost {
            case .announcement(_): value += "Announcement"
            case .courseWork(let courseWork): value += courseWork.title
            case .courseMaterial(let courseWorkMaterial): value += courseWorkMaterial.title
            }
        }

        if !value.isEmpty { value += ": " }

        if let selectedCourse {
            switch selectedCourse {
            case .course(let string):
                let configuration = GlobalCoursesDataManager.global.configuration
                value += configuration.nameFor(GlobalCoursesDataManager.global.courseIdMap[string]?.name ?? "")
            case .allTeaching:
                value += "Teaching"
            case .allEnrolled:
                value += "Enrolled"
            case .group(let string):
                let configuration = GlobalCoursesDataManager.global.configuration
                value += configuration.groupIdMap[string]?.groupName ?? ""
            }
        }

        value = value.trunc(length: 30)

        if value.isEmpty {
            return "Glassroom"
        }
        return value
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
                        .frame(minWidth: 400)
                } rView: {
                    ZStack {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                        DetailView(selectedCourse: $selectedCourse, selectedPost: $selectedPost)
                    }
                    .frame(minWidth: 400)
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
        GeometryReader { geometry in
            NavigationSplitView(columnVisibility: $columnVisibility) {
                SidebarView(selection: $selectedCourse)
                    #if os(iOS)
                    .toolbar {
                        if UIScreen.main.traitCollection.userInterfaceIdiom == .pad {
                            if geometry.size.width >= 680 {
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button {
                                        showSearch.toggle()
                                    } label: {
                                        Image(systemName: "magnifyingglass")
                                    }
                                    .keyboardShortcut("O", modifiers: [.command, .shift])
                                }
                            }
                        }
                    }
                    .sheet(isPresented: $showSearch) {
                        ZStack {
                            Color(.systemBackground).opacity(0.000001)
                                .onTapGesture {
                                    showSearch.toggle()
                                }
                            SearchView(selectedCourse: $selectedCourse,
                                       selectedPost: $selectedPost)
                        }
                        .presentationBackground(.clear)
                    }
                    #endif
            } content: {
                CenterSplitView(selectedCourse: $selectedCourse, selectedPost: $selectedPost)
                #if os(macOS)
                    .frame(minWidth: 400)
                #endif
                #if os(iOS)
                    .navigationBarTitleDisplayMode(.inline)
                #endif
            } detail: {
                DetailView(selectedCourse: $selectedCourse, selectedPost: $selectedPost)
                #if os(macOS)
                    .frame(minWidth: 400)
                #endif
                #if os(iOS)
                    .navigationBarTitleDisplayMode(.inline)
                #endif
            }
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

extension String {
    func trunc(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
}
