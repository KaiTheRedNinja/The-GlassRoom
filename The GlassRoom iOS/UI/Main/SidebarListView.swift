//
//  SidebarListView.swift
//  The GlassRoom iOS
//
//  Created by Kai Quan Tay on 1/7/23.
//

import SwiftUI

struct SidebarListView: View {
    @Binding var selection: GeneralCourse?
    @ObservedObject var coursesManager: GlobalCoursesDataManager = .global

    var body: some View {
        List(selection: $selection) {
            ForEach(coursesManager.courses) { course in
                SidebarCourseView(course: .course(course.id))
                    .tag(GeneralCourse.course(course.id))
            }
        }
        .navigationTitle(UIScreen.main.traitCollection.userInterfaceIdiom == .pad ? "Glassroom" : "")
        .listStyle(.insetGrouped)
        .onAppear {
            coursesManager.loadList()
        }
    }
}
