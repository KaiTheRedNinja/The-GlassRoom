//
//  CoursesConfiguration+Archive.swift
//  
//
//  Created by Kai Quan Tay on 12/10/23.
//

import Foundation

extension CoursesConfiguration {
    // MARK: Archive, groups
    public func archive(item: GeneralCourse) {
        let isArchived = archive?.courses.contains(item.id) ?? false

        if isArchived {
            archive?.courses.removeAll(where: { $0.id == item.id })
        } else {
            var archivingCourses: [String] = []

            switch item {
            case .group(let string):
                // archive all courses in the group
                guard let groupIndex = courseGroups.firstIndex(where: { $0.id == string })
                else { return }
                archivingCourses = courseGroups.remove(at: groupIndex).courses
            case .course(let string):
                // archive that course
                print("Archiving course \(string)")
                archivingCourses = [string]
            default: return
            }
            if archive == nil {
                archive = .init(
                    id: CourseGroup.archiveId,
                    groupName: CourseGroup.archiveId,
                    groupType: .enrolled,
                    courses: archivingCourses)
            } else {
                archive?.courses.append(contentsOf: archivingCourses)
                objectWillChange.send()
            }
            saveToFileSystem()
        }
    }
}
