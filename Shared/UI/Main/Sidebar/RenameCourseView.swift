//
//  RenameCourseView.swift
//  Glassroom
//
//  Created by Kai Quan Tay on 19/1/24.
//

import SwiftUI
import GlassRoomInterface

struct RenameCourseView: View {
    @ObservedObject var configuration: CoursesConfiguration = .global
    @ObservedObject var manager: GlobalCoursesDataManager = .global
    @Environment(\.presentationMode) var presentationMode

    var courseString: String

    init(courseString: String) {
        self.courseString = courseString
    }

    var body: some View {
#if os(macOS)
        VStack {
            if let course = manager.courseIdMap[courseString] {
                TextField("\(course.name)", text: .init(get: {
                    configuration.renamedCourses[courseString] ?? course.name
                }, set: { newValue in
                    configuration.renamedCourses[courseString] = newValue
                }))
                HStack {
                    Spacer()
                    Button("Cancel", role: .cancel) {
                        configuration.renamedCourses.removeValue(forKey: courseString)
                        configuration.saveToFileSystem()
                        presentationMode.wrappedValue.dismiss()
                    }
                    Button("Save") {
                        configuration.saveToFileSystem()
                        configuration.objectWillChange.send()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .onSubmit {
                        configuration.saveToFileSystem()
                        configuration.objectWillChange.send()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            } else {
                Text("No Course")
            }
        }
        .padding(15)
        .frame(width: 200, height: 170)
#else
        if let course = manager.courseIdMap[courseString] {
            TextField("\(course.name)", text: .init(get: {
                configuration.renamedCourses[courseString] ?? course.name
            }, set: { newValue in
                configuration.renamedCourses[courseString] = newValue
            }))
            Button("Cancel", role: .cancel) {
                configuration.renamedCourses.removeValue(forKey: courseString)
                configuration.saveToFileSystem()
                presentationMode.wrappedValue.dismiss()
            }
            Button("Save") {
                configuration.saveToFileSystem()
                configuration.objectWillChange.send()
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(.borderedProminent)
            .onSubmit {
                configuration.saveToFileSystem()
                configuration.objectWillChange.send()
                presentationMode.wrappedValue.dismiss()
            }
        } else {
            Text("No Course")
        }
#endif
    }
}
