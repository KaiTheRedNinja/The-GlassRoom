//
//  CourseCourseWorksContentsListView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 14/5/23.
//

import SwiftUI
import GlassRoomAPI

struct CourseCourseWorksContentsListView: View {
    @Binding var selectedPost: CoursePost?
    @ObservedObject var courseWorksManager: CourseCourseWorksDataManager

    var body: some View {
        ZStack {
            if !courseWorksManager.courseWorks.isEmpty {
                courseWorksContent
            } else {
                VStack {
                    Text("No Course Work")
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
                    courseWorksManager.loadList()
                    courseWorksManager.loadList(bypassCache: true)
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .buttonStyle(.plain)
                .contextMenu {
                    Button("Use Cache") {
                        courseWorksManager.loadList()
                    }
                }
                .offset(y: -1)

                if courseWorksManager.loading {
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

    var courseWorksContent: some View {
        List {
            ForEach(courseWorksManager.courseWorks, id: \.id) { courseWork in
                Button {
                    selectedPost = .courseWork(courseWork)
                } label: {
                    VStack(alignment: .leading) {
                        Text(courseWork.title)
                            .font(.title3)
                            .fontWeight(.bold)
                            .lineLimit(2)

                        HStack {
                            Image(systemName: "timer")

                            Text(convertDate(courseWork.creationTime, .long, .standard))

                            if convertDate(courseWork.updateTime) != convertDate(courseWork.creationTime) {
                                // updateTime and creationTime are not the same
                                if convertDate(courseWork.updateTime, .long, .omitted) == convertDate(courseWork.creationTime, .long, .omitted) {
                                    // updated on the same day, shows time instead
                                    Text("(Edited \(convertDate(courseWork.updateTime, .omitted, .standard)))")
                                } else {
                                    // updated on different day, shows day instead
                                    Text("(Edited \(convertDate(courseWork.updateTime, .abbreviated, .omitted)))")
                                }
                            }
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(5)
                    .background(selectedPost?.id == courseWork.id ? .blue : .clear)
                    .cornerRadius(6)
                }
                .buttonStyle(.plain)
                .padding(.vertical, 2)
            }

            if let token = courseWorksManager.nextPageToken {
                Button("Load next page") {
                    courseWorksManager.refreshList(nextPageToken: token)
                }
            }
        }
    }
}
