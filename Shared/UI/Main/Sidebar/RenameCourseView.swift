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

    @State var newName: String

    var generalCourse: GeneralCourse
    var initialName: String?

    init(generalCourse: GeneralCourse) {
        self.generalCourse = generalCourse
        
        let initialName: String?

        switch generalCourse {
        case .course(let courseString):
            let course = GlobalCoursesDataManager.global.courseIdMap[courseString]
            initialName = if let course { CoursesConfiguration.global.nameFor(course) } else { nil }
        case .group(let groupString):
            let group = CoursesConfiguration.global.groupIdMap[groupString]
            initialName = group?.groupName
        default: fatalError("Invalid Use")
        }

        self.initialName = initialName
        self._newName = .init(initialValue: initialName ?? "Untitled Course")
    }

    var body: some View {
        TextField("New Name", text: $newName)
        Button("Cancel", role: .cancel, action: cancel)

        switch generalCourse {
        case .course(let string):
            Button("Revert", action: revert)
        default: EmptyView()
        }

        Button("Save", action: submit)
    }

    func cancel() {
        presentationMode.wrappedValue.dismiss()
    }

    func revert() {
        configuration.renamedCourses.removeValue(forKey: generalCourse.id)
        configuration.saveToFileSystem()
        presentationMode.wrappedValue.dismiss()
    }

    func submit() {
        switch generalCourse {
        case .course(let string):
            configuration.renamedCourses[string] = newName
        case .group(let string):
            if let index = configuration.courseGroups.firstIndex(where: { $0.id == string }) {
                configuration.courseGroups[index].groupName = newName
            }
        default: fatalError()
        }
        configuration.saveToFileSystem()
        configuration.objectWillChange.send()
        presentationMode.wrappedValue.dismiss()
    }
}
