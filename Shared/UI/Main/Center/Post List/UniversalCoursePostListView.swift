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
        .safeAreaInset(edge: .bottom) {
            ZStack {
                HStack {
                    Spacer()
                    if let course = self.course {
                        Text(configuration.nameFor(course))
                            .multilineTextAlignment(.center)
                            .font(.headline)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .padding(.horizontal, 30)
                    }
                    Spacer()
                }
                HStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                    } else {
                        Button {
                            loadList(false)
                            loadList(true)
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .font(.title2)
                        }
                        .keyboardShortcut("r", modifiers: .command)
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button("Use Cache") {
                                loadList(true)
                            }
                        }
                        .help("Refresh Posts (⌘R)")
                    }
                    Spacer()
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
            .padding(.bottom, -10)
            .background(.ultraThinMaterial)
        }
        .searchable(text: $searchQuery)
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
