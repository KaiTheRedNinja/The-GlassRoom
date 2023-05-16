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

    @State var colorChangingCourse: Course?

    var body: some View {
        SidebarOutlineView(
            selectedCourse: $selection,
            colorChangingCourse: $colorChangingCourse,
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
//        .sheet(item: $colorChangingCourse) { _ in
//
//        }
    }
}

extension Course: Identifiable, Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
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

    @ObservedObject var coursesManager: GlobalCoursesDataManager = .global

    var body: some View {
        HStack {
            coursesManager.configuration.colorFor(course.id)
                .frame(width: 6)
                .cornerRadius(3)
                .padding(.vertical, 3)
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
            .padding(.trailing, 5)
        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(selection: .constant(nil))
    }
}
