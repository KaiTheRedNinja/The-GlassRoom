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
                CoursePostItem(coursework: courseWork, selectedPost: $selectedPost)
            }

            if let token = courseWorksManager.nextPageToken {
                Button("Load next page") {
                    courseWorksManager.refreshList(nextPageToken: token)
                }
            }
        }
    }
}
