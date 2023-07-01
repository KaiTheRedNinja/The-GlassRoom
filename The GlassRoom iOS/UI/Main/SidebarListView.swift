//
//  SidebarListView.swift
//  The GlassRoom iOS
//
//  Created by Kai Quan Tay on 1/7/23.
//

import SwiftUI
import GlassRoomTypes

struct SidebarListView: View {
    @Binding var selection: GeneralCourse?
    @ObservedObject var coursesManager: GlobalCoursesDataManager = .global

    var body: some View {
        List(selection: $selection) {
            Section("Teaching") {
                viewForCourseType(type: .teaching)
            }
            Section("Enrolled") {
                viewForCourseType(type: .enrolled)
            }
        }
        .navigationTitle(UIScreen.main.traitCollection.userInterfaceIdiom == .pad ? "Glassroom" : "")
        .listStyle(.insetGrouped)
        .onAppear {
            coursesManager.loadList()
        }
    }

    func viewForCourseType(type: Course.CourseType) -> some View {
        ForEach(coursesManager.courses.filter({ $0.courseType == type })) { course in
            SidebarCourseView(course: .course(course.id))
                .tag(GeneralCourse.course(course.id))
        }
    }
}
