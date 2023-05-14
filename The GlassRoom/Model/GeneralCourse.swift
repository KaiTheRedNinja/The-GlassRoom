//
//  GeneralCourse.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 14/5/23.
//

import Foundation
import GlassRoomAPI

enum GeneralCourse: Hashable, Identifiable {
    case course(Course)
    case allTeaching
    case allEnrolled

    var id: String {
        switch self {
        case .course(let course):
            return course.id
        case .allTeaching:
            return "allTeaching"
        case .allEnrolled:
            return "allEnrolled"
        }
    }

    static func == (lhs: GeneralCourse, rhs: GeneralCourse) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
