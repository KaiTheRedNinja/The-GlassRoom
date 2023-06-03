//
//  SidebarCourseView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 3/6/23.
//

import SwiftUI
import Combine

struct SidebarCourseView: View {
    var course: GeneralCourse

    @ObservedObject var coursesManager: GlobalCoursesDataManager = .global
    @ObservedObject var configuration: GlobalCoursesDataManager.CoursesConfiguration = GlobalCoursesDataManager.global.configuration

    @State var coursePostsDataManagerWatcher: AnyCancellable?
    @State var postDataManagerWatcher: AnyCancellable?
    @State var isUnloaded: Bool = false

    var body: some View {
        ZStack {
            content
        }
    }

    @ViewBuilder
    var content: some View {
        switch course {
        case .course(let string):
            if let course = coursesManager.courseIdMap[string] {
                HStack {
                    configuration.colorFor(course.id)
                        .frame(width: 6)
                        .cornerRadius(3)
                        .padding(.vertical, 3)
                    VStack {
                        HStack {
                            Text(configuration.nameFor(course.name))
                                .lineLimit(1)
                            Spacer()
                        }
                        if let description = course.description {
                            HStack {
                                Text(description)
                                    .font(.caption)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                                Spacer()
                            }
                        }
                    }
                }
                .opacity(isUnloaded ? 0.4 : 1)
                .onAppear {
                    coursePostsDataManagerWatcher = CoursePostsDataManager.loadedManagersPublisher.sink { value in
                        testForLoad(value: value, id: string)
                    }
                }
            } else {
                Text("Invalid Course")
            }
        case .allTeaching, .allEnrolled:
            let title = course == .allTeaching ? "Teaching" : "Enrolled"
            HStack {
                Text(title)
                    .bold()
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.horizontal, 5)
            .disabled(true)
        case .group(let string):
            if string == CourseGroup.archiveId {
                HStack {
                    Text("Archive")
                        .bold()
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.horizontal, 5)
                .disabled(true)
            } else if let group = configuration.groupIdMap[string] {
                HStack {
                    Image(systemName: "folder.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                        .offset(x: 3)
                        .foregroundColor(.accentColor)
                        .disabled(true)
                    VStack {
                        HStack {
                            Text(group.groupName)
                                .lineLimit(1)
                            Spacer()
                        }
                    }
                }
            } else {
                Text("Invalid course group")
            }
        }
    }

    func testForLoad(value: [String: CoursePostsDataManager], id: String) {
        let postsManager = value[id]
        if let postsManager, postDataManagerWatcher == nil {
            postDataManagerWatcher = postsManager.objectWillChange.sink {
                testForLoad(postsManager: postsManager)
            }
        }
        testForLoad(postsManager: postsManager)
    }

    func testForLoad(postsManager: CoursePostsDataManager?) {
        isUnloaded = (postsManager == nil || postsManager!.postDataIsEmpty)
    }
}
