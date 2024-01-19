//
//  BreadcrumbsView.swift
//  Glassroom
//
//  Created by Kai Quan Tay on 19/1/24.
//

import SwiftUI
import GlassRoomTypes
import GlassRoomInterface

struct BreadcrumbsView: View {
    @Binding var selectedCourse: GeneralCourse?
    @Binding var selectedPost: CoursePost?

    @ObservedObject var manager: GlobalCoursesDataManager = .global
    @ObservedObject var config: CoursesConfiguration = .global

    var body: some View {
        HStack {
            Text("Glassroom")
                .font(.title2)
                .onTapGesture {
                    selectedCourse = nil
                    selectedPost = nil
                }

            if let selectedCourse {
                HStack {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                    switch selectedCourse {
                    case .course(let string):
                        if let course = manager.courseIdMap[string] {
                            Text(config.nameFor(course))
                        } else {
                            Text("Untitled Course")
                        }
                    case .allTeaching:
                        Text("Teaching")
                    case .allEnrolled:
                        Text("Enrolled")
                    case .group(let string):
                        if let group = config.groupIdMap[string] {
                            Text(group.groupName)
                        } else if string == CourseGroup.archiveId {
                            Text("Archive")
                        } else {
                            Text("Untitled Group")
                        }
                    }
                }
                .font(.title2)
                .onTapGesture {
                    selectedPost = nil
                }
            }

            if let selectedPost {
                Group {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                    switch selectedPost {
                    case .announcement(_):
                        Text("Announcement")
                    case .courseWork(let courseWork):
                        Text(courseWork.title)
                    case .courseMaterial(let courseWorkMaterial):
                        Text(courseWorkMaterial.title)
                    }
                }
                .font(.title3)
                .opacity(selectedPost.courseId == selectedCourse?.id ? 1 : 0.5)
            }
        }
    }
}
