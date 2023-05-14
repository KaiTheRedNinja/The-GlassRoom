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

    var id: String {
        switch self {
        case .announcement(let courseAnnouncement):
            return courseAnnouncement.id
        case .courseWork(let courseWork):
            return courseWork.id
        }
    }

    static func == (lhs: CoursePost, rhs: CoursePost) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
