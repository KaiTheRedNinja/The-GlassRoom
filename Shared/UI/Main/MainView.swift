//
//  MainView.swift
//  The GlassRoom
//
//  Created by Tristan on 11/05/2023.
//

import SwiftUI
import GlassRoomTypes
import GlassRoomInterface

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
            toolbar
        }
        .onAppear {
            loadCachedStreams()
        }
        .navigationTitle("")
        #else
        splitView
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
//                        .frame(minWidth: 400)
                } rView: {
                    ZStack {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                        DetailView(selectedCourse: $selectedCourse, selectedPost: $selectedPost)
                    }
//                    .frame(minWidth: 400)
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
                                    .help("Universal Search (⌘⇧O)")
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
        let archived = CoursesConfiguration.global.archive?.courses ?? []
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
