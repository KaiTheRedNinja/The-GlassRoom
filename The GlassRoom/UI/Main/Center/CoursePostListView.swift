//
//  CoursePostListView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 14/5/23.
//

import SwiftUI
import GlassRoomAPI

struct CoursePostListView: View {
    @Binding var selectedPost: CoursePost?
    var postData: [CoursePost]
    var isEmpty: Bool
    var isLoading: Bool
    var hasNextPage: Bool
    /// Load the list, optionally bypassing the cache
    var loadList: (_ bypassCache: Bool) -> Void
    /// Refresh, using the next page token if needed
    var refreshList: () -> Void

    var body: some View {
        ZStack {
            if !isEmpty {
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
        .safeAreaInset(edge: .bottom) {
            HStack(alignment: .center) {
                Button {
                    loadList(false)
                    loadList(true)
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .buttonStyle(.plain)
                .contextMenu {
                    Button("Use Cache") {
                        loadList(true)
                    }
                }
                .offset(y: -1)

                if isLoading {
                    ProgressView()
                        .progressViewStyle(.linear)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                } else {
                    Spacer()
                }
            }
            .padding(.horizontal, 5)
            .frame(height: 25)
            .frame(maxWidth: .infinity)
            .background(.thinMaterial)
            .overlay(alignment: .top) {
                Divider()
            }
            .padding(.top, -7)
        }
    }

    var postsContent: some View {
        List {
            ForEach(postData, id: \.id) { post in
                switch post {
                case .announcement(let announcement):
                    CoursePostItem(announcement: announcement, selectedPost: $selectedPost)
                case .courseWork(let courseWork):
                    CoursePostItem(coursework: courseWork, selectedPost: $selectedPost)
                }
            }

            if hasNextPage {
                Button("Load next page") {
                    refreshList()
                }
            }
        }
    }
}

struct CourseAnnouncementsAdaptorView: View {
    @Binding var selectedPost: CoursePost?
    @ObservedObject var announcementManager: CourseAnnouncementsDataManager

    var body: some View {
        CoursePostListView(selectedPost: $selectedPost,
                           postData: announcementManager.courseAnnouncements.map({ .announcement($0) }),
                           isEmpty: announcementManager.courseAnnouncements.isEmpty,
                           isLoading: announcementManager.loading,
                           hasNextPage: announcementManager.nextPageToken != nil,
                           loadList: announcementManager.loadList,
                           refreshList: { announcementManager.refreshList() })
    }
}

struct CourseCourseWorksAdaptorView: View {
    @Binding var selectedPost: CoursePost?
    @ObservedObject var courseWorksManager: CourseCourseWorksDataManager

    var body: some View {
        CoursePostListView(selectedPost: $selectedPost,
                           postData: courseWorksManager.courseWorks.map({ .courseWork($0) }),
                           isEmpty: courseWorksManager.courseWorks.isEmpty,
                           isLoading: courseWorksManager.loading,
                           hasNextPage: courseWorksManager.nextPageToken != nil,
                           loadList: courseWorksManager.loadList,
                           refreshList: { courseWorksManager.refreshList() })
    }
}
