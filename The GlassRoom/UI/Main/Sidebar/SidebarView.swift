//
//  SidebarView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 13/5/23.
//

import SwiftUI
import GlassRoomAPI

struct SidebarView: View {
    @Binding var selection: GeneralCourse?
    @ObservedObject var coursesManager: GlobalCoursesDataManager = .global

    var body: some View {
        SidebarOutlineView(
            selectedCourse: $selection,
            courses: coursesManager.courses
        )
        .overlay {
            if coursesManager.courses.isEmpty {
                VStack {
                    Text("No Courses")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                }
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
    var type: Course.CourseType

    var body: some View {
        HStack {
            Text(type.rawValue)
                .bold()
                .foregroundColor(.gray)
                .padding(.bottom, 2.5)
            Spacer()
        }
        .padding(.horizontal, 5)
        .disabled(true)
    }
}

struct CourseView: View {
    var course: Course

    var body: some View {
        VStack {
            let isLoaded = CoursePostsDataManager.loadedManagers.keys.contains(course.id)
            HStack {
                Text(course.name)
//                    .font(.system(.body, weight: isLoaded ? .semibold : .regular))
                    .lineLimit(1)
//                    .opacity(isLoaded ? 1 : 0.5)
                Spacer()
            }
            if let description = course.description {
                HStack {
                    Text(description)
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
//                        .opacity(isLoaded ? 1 : 0.5)
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
