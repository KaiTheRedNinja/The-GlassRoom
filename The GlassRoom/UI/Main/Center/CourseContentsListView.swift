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
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Button("Reload") {
                    courseAnnouncementsManager.loadList()
                }
                Button("Full Reload") {
                    courseAnnouncementsManager.loadList()
                    courseAnnouncementsManager.loadList(bypassCache: true)
                }
                if courseAnnouncementsManager.loading {
                    ProgressView()
                        .progressViewStyle(.linear)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                }
            }
        }
    }
}
