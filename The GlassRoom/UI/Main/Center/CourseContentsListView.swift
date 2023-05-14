//
//  CourseContentsListView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 14/5/23.
//

import SwiftUI
import GlassRoomAPI

struct CourseContentsListView: View {
    @Binding var selectedPost: CourseAnnouncement?
    @ObservedObject var courseAnnouncementsManager: CourseAnnouncementsDataManager

    var body: some View {
        ZStack {
            if !courseAnnouncementsManager.courseAnnouncements.isEmpty {
                announcementsContent
            } else {
                VStack {
                    Text("No Announcements")
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
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .buttonStyle(.plain)
                .contextMenu {
                    Button("Use Cache") {
                        courseAnnouncementsManager.loadList()
                    }
                }
                .offset(y: -1)

                if courseAnnouncementsManager.loading {
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

    var announcementsContent: some View {
        List {
            ForEach(courseAnnouncementsManager.courseAnnouncements, id: \.id) { announcement in
                Button {
                    selectedPost = announcement
                } label: {
                    VStack(alignment: .leading) {
                        Text(announcement.text)
                            .font(.title3)
                            .fontWeight(.bold)
                            .lineLimit(1)

                        Text(announcement.creationTime)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(5)
                    .background(selectedPost?.id == announcement.id ? .blue : .clear)
                    .cornerRadius(6)
                }
                .buttonStyle(.plain)
            }
            if let token = courseAnnouncementsManager.nextPageToken {
                Button("Load next page") {
                    courseAnnouncementsManager.refreshList(nextPageToken: token)
                }
            }
        }
    }
}
