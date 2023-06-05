//
//  CoursePost.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 14/5/23.
//

import Foundation
import GlassRoomTypes

enum CoursePost: Hashable, Identifiable, Codable {
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

    var updateDate: Date {
        switch self {
        case .announcement(let courseAnnouncement):
            return courseAnnouncement.updateDate
        case .courseWork(let courseWork):
            return courseWork.updateDate
        case .courseMaterial(let courseWorkMaterial):
            return courseWorkMaterial.updateDate
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

    struct MinimalRepresentation: Codable, Identifiable, Hashable {
        var courseId: String
        var id: String
    }

    var minimalRepresentation: MinimalRepresentation {
        .init(courseId: courseId, id: id)
    }
}
