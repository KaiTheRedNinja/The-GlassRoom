//
//  CoursePost.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 14/5/23.
//

import Foundation
import GlassRoomAPI

enum CoursePost: Hashable, Identifiable {
    case announcement(CourseAnnouncement)
    case courseWork(CourseWork)
    case courseMaterial(CourseWorkMaterial)

    var id: String {
        switch self {
        case .announcement(let courseAnnouncement):
            return courseAnnouncement.id
        case .courseWork(let courseWork):
            return courseWork.id
        case .courseMaterial(let courseMaterial):
            return courseMaterial.id
        }
    }

    var creationDate: Date {
        switch self {
        case .announcement(let courseAnnouncement):
            return courseAnnouncement.creationDate
        case .courseWork(let courseWork):
            return courseWork.creationDate
        case .courseMaterial(let courseMaterial):
            return courseMaterial.creationDate
        }
    }

    var courseId: String {
        switch self {
        case .announcement(let courseAnnouncement):
            return courseAnnouncement.courseId
        case .courseWork(let courseWork):
            return courseWork.courseId
        case .courseMaterial(let courseWorkMaterial):
            return courseWorkMaterial.courseId
        }
    }

    static func == (lhs: CoursePost, rhs: CoursePost) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
