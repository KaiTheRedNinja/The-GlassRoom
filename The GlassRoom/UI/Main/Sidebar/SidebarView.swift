//
//  SidebarView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 13/5/23.
//

import SwiftUI
import GlassRoomAPI

struct SidebarView: View {
    @Binding var selection: Course?
    @ObservedObject var coursesManager: GlobalCoursesDataManager = .global

    var body: some View {
        SidebarOutlineView(
            selectedCourse: $selection,
            courses: coursesManager.courses
        )
        .overlay {
            if coursesManager.courses.isEmpty {
                Text("No Classes")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
        }
        .safeAreaInset(edge: .bottom) {
            if coursesManager.loading {
                ProgressView()
                    .progressViewStyle(.linear)
                    .frame(maxWidth: .infinity)
                    .padding(10)
            }
        }
        .onAppear {
            guard coursesManager.courses.isEmpty else { return }
            coursesManager.loadList()
        }
    }
}

struct CourseCategoryHeaderView: View {
    var name: String

    var body: some View {
        HStack {
            Text(name)
                .bold()
                .foregroundColor(.gray)
                .padding(.bottom, 2.5)
            Spacer()
        }
        .padding(.horizontal, 5)
    }
}

struct CourseView: View {
    var course: Course

    var body: some View {
        VStack {
            HStack {
                Text(course.name)
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
        .padding(.horizontal, 5)
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(selection: .constant(nil))
    }
}
