//
//  CoursePostContentsListView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 14/5/23.
//

import SwiftUI

struct CoursePostContentsListView: View {
    @Binding var selectedPost: CoursePost?
    @ObservedObject var courseAnnouncementsManager: CourseAnnouncementsDataManager
    @ObservedObject var courseWorksManager: CourseCourseWorksDataManager

    var body: some View {
        ZStack {
            if !(courseAnnouncementsManager.courseAnnouncements.isEmpty && courseWorksManager.courseWorks.isEmpty ) {
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
                    courseAnnouncementsManager.loadList()
                    courseAnnouncementsManager.loadList(bypassCache: true)
                    courseWorksManager.loadList()
                    courseWorksManager.loadList(bypassCache: true)
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .buttonStyle(.plain)
                .contextMenu {
                    Button("Use Cache") {
                        courseAnnouncementsManager.loadList()
                        courseWorksManager.loadList()
                    }
                }
                .offset(y: -1)

                if courseAnnouncementsManager.loading || courseWorksManager.loading {
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

            if let token = courseAnnouncementsManager.nextPageToken {
                Button("Load next page") {
                    courseAnnouncementsManager.refreshList(nextPageToken: token)
                }
            }
        }
    }

    var postData: [CoursePost] {
        let announcements = courseAnnouncementsManager.courseAnnouncements.map({ CoursePost.announcement($0) })
        let courseWorks = courseWorksManager.courseWorks.map({ CoursePost.courseWork($0) })
        let unified = announcements.mergedWith(other: courseWorks,
                                               isSame: { $0.id == $1.id },
                                               isBefore: { $0.creationDate > $1.creationDate })

        return unified
    }
}
