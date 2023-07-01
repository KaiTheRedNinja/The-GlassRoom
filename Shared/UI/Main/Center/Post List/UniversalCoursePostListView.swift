//
//  UniversalCoursePostListView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 14/5/23.
//

import SwiftUI
import GlassRoomAPI

struct UniversalCoursePostListView: View {
    
    @State var searchText = String()
    @Binding var selectedPost: CoursePost?

    var showPostCourseOrigin: Bool = false

    var postData: [CoursePost]
    var isLoading: Bool
    var hasNextPage: Bool
    /// Load the list, optionally bypassing the cache
    var loadList: (_ bypassCache: Bool) -> Void
    /// Refresh, using the next page token if needed
    var refreshList: () -> Void
    
    var onPlusPress: (() -> Void)?

    var body: some View {
        ZStack {
            if !postData.isEmpty {
                postsContent
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
                    .keyboardShortcut("r", modifiers: .command)
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button("Use Cache") {
                            loadList(true)
                        }
                    }
                    .offset(y: -1)
                }
                
                Spacer()
                
                if let onPlusPress {
                    Button {
                        onPlusPress()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(.plain)
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
        .toolbar {
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
            
            ToolbarItem(placement: .bottomBar) {
                if let onPlusPress {
                    Button {
                        onPlusPress()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .searchable(text: $searchText)
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
}
