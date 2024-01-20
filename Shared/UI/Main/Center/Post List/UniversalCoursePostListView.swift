//
//  UniversalCoursePostListView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 14/5/23.
//

import SwiftUI
import GlassRoomAPI
import GlassRoomTypes
import GlassRoomInterface
#if os(macOS)
import KeyboardShortcuts
#endif

struct UniversalCoursePostListView: View {
    
    @State var isInSearch: Bool
    @State var value = 0.0
    
    @Binding var currentPage: CourseDisplayOption
    
    @State var searchQuery: String = ""
    @Binding var selectedPost: CoursePost?

    var course: Course?
    var showPostCourseOrigin: Bool = false

    var postData: [CoursePost]
    var isLoading: Bool
    var hasNextPage: Bool
    /// Load the list, optionally bypassing the cache
    var loadList: (_ bypassCache: Bool) -> Void
    /// Refresh, using the next page token if needed
    var refreshList: () -> Void
    
    var onPlusPress: (() -> Void)?
    
    @ObservedObject var postsManager: CoursePostsDataManager
    @ObservedObject var profilesManager: GlobalUserProfilesDataManager = .global
    @ObservedObject var configuration: CoursesConfiguration = .global

    var body: some View {
        ZStack {
            if !postData.isEmpty {
                if searchQuery.isEmpty {
                    postsContent
                } else {
                    searchPostsContent
                }
            } else {
                VStack {
                    Text("No Posts")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                }
                .frame(maxHeight: .infinity)
            }
        }
        .animation(.default, value: postData)
        #if os(macOS)
        .safeAreaInset(edge: .bottom) {
            HStack(alignment: .center) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(.init(0.45))
                        .offset(x: -10)
                } else {
                    Button {
                        loadList(false)
                        loadList(true)
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
//                    .onKeyboardShortcut(.reloadCoursePosts, type: .keyDown) {
//                        loadList(false)
//                        loadList(true)
//                    }
                    .keyboardShortcut("r", modifiers: [.command])
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button("Use Cache") {
                            loadList(true)
                        }
                    }
                    .offset(y: -1)
                    .help("Refresh Posts (⌘R)")
                }
                
                Spacer()
                
                if !isInSearch {
//                    if let onPlusPress {
//                        Button {
//                            onPlusPress()
//                        } label: {
//                            Image(systemName: "plus")
//                        }
//                        .buttonStyle(.plain)
//                    }
                    Text(" ")
                }
            }
            .padding(.horizontal, 5)
            .frame(height: 25)
            .frame(maxWidth: .infinity)
            .background(.thinMaterial)
            .overlay(alignment: .top) {
                VStack(spacing: 0) {
                    Divider()
                }
            }
            .padding(.top, -7)
        }
        #else
        .refreshable {
            loadList(false)
            loadList(true)
        }
        .toolbar {
            if UIScreen.main.traitCollection.userInterfaceIdiom == .pad {
                ToolbarItem(placement: .bottomBar) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                    } else {
                        Button {
                            loadList(false)
                            loadList(true)
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                        .keyboardShortcut("r", modifiers: .command)
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button("Use Cache") {
                                loadList(true)
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: .status) {
                    if let course = self.course {
                        Text(configuration.nameFor(course))
                            .multilineTextAlignment(.center)
                            .font(.headline)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .padding(.horizontal, 30)
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    //                if isInSearch {
                    //                    Text(" ")
                    //                } else {
                    //                    if let onPlusPress {
                    //                        Button {
                    //                            onPlusPress()
                    //                        } label: {
                    //                            Image(systemName: "plus")
                    //                        }
                    //                        .buttonStyle(.plain)
                    //                    }
                    //                }
                    Text(" ")
                }
            } else {
                ToolbarItem(placement: .principal) {
                    if let course = self.course {
                        Text(configuration.nameFor(course))
                            .multilineTextAlignment(.center)
                            .font(.headline)
                            .fontWeight(.bold)
                            .lineLimit(1)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                    } else {
                        Button {
                            loadList(false)
                            loadList(true)
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                        .keyboardShortcut("r", modifiers: .command)
                        .padding(.horizontal, -10)
                        .contextMenu {
                            Button("Use Cache") {
                                loadList(true)
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Picker("", selection: $currentPage) {
                        Label("All Posts", systemImage: "list.bullet")
                            .tag(CourseDisplayOption.allPosts)
                        Divider()
                        Label("Announcements", systemImage: "megaphone")
                            .tag(CourseDisplayOption.announcements)
                        Label("Courseworks", systemImage: "square.and.pencil")
                            .tag(CourseDisplayOption.courseWork)
                        Label("Materials", systemImage: "doc")
                            .tag(CourseDisplayOption.courseMaterial)
                        Label("Resources", systemImage: "link")
                            .tag(CourseDisplayOption.resources)
                        //                    Label("Register", systemImage: "person.2")
                        //                        .tag(CourseDisplayOption.userRegister)
                    }
                    .pickerStyle(.menu)
                    .padding(.horizontal, -10)
                }
            }
        }
        .searchable(text: $searchQuery)
        .overlay {
            if queryPosts(query: searchQuery).isEmpty && !searchQuery.isEmpty {
                if #available(iOS 17.0, *) {
                    ContentUnavailableView {
                        Label("No Posts containing \"\(searchQuery)\"", systemImage: "doc.questionmark")
                    } description: {
                        Text("Check the spelling or try a new search.")
                    }
                }
            }
        }
        .toolbar(isInSearch ? .hidden : .visible, for: .navigationBar)
        #endif
    }

    @ObservedObject var courseManager: GlobalCoursesDataManager = .global

    var postsContent: some View {
        List(selection: $selectedPost) {
            CoursePostListView(postData: postData, showPostCourseOrigin: showPostCourseOrigin)

            if hasNextPage {
                Button("Load next page") {
                    refreshList()
                }
            }
        }
    }
    
    var searchPostsContent: some View {
        List(selection: $selectedPost) {
            CoursePostListView(postData: queryPosts(query: searchQuery), showPostCourseOrigin: showPostCourseOrigin)

            if hasNextPage {
                Button("Load next page") {
                    refreshList()
                }
            }
        }
    }
    
    func queryPosts(query: String) -> [CoursePost] {
        return postData.filter { post in
            switch post {
            case .announcement(let announcement):
                if announcement.text.lowercased().contains(searchQuery.lowercased()) {
                    return true
                }
            case .courseWork(let courseWork):
                if courseWork.title.lowercased().contains(searchQuery.lowercased()) {
                    return true
                }
            case .courseMaterial(let courseMaterial):
                if courseMaterial.title.lowercased().contains(searchQuery.lowercased()) {
                    return true
                }
            }
            
            return false
        }
    }
}
