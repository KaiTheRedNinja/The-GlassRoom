//
//  SidebarCourseView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 3/6/23.
//

import SwiftUI
import Combine
import GlassRoomInterface

struct SidebarCourseView: View {
    var course: GeneralCourse

    @ObservedObject var coursesManager: GlobalCoursesDataManager = .global
    @ObservedObject var configuration: CoursesConfiguration = .global

    @State var coursePostsDataManagerWatcher: AnyCancellable?
    @State var postDataManagerWatcher: AnyCancellable?
    @State var isUnloaded: Bool = false
    
    @AppStorage("lowerUnloadedOpacity") var lowerUnloadedOpacity: Bool = false

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
                    Circle()
                        .fill(configuration.colorFor(course.id))
                        .reverseMask {
                            Image(systemName: configuration.iconFor(course.id))
                                .resizable()
                                .scaledToFit()
                                .padding(3)
                        }
                        #if os(macOS)
                        .frame(width: 16, height: 16)
                        #else
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 5)
                        #endif
                        .offset(x: 3)
                        .foregroundColor(.accentColor)
                        .disabled(true)
                    VStack {
                        HStack {
                            Text(configuration.nameFor(course))
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
                .opacity(lowerUnloadedOpacity ? isUnloaded ? 0.4 : 1 : 1)
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
                    #if os(macOS)
                        .frame(width: 16, height: 16)
                    #else
                        .frame(width: 24, height: 24)
                    #endif
                        .offset(x: 3)
                        .foregroundColor(.accentColor)
                        .disabled(true)
                    VStack {
                        HStack {
                            Text(group.groupName)
                                .lineLimit(1)
                            #if os(iOS)
                                .offset(x: 5)
                            #endif
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
