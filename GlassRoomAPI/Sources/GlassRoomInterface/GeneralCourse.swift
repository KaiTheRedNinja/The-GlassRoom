//
//  GeneralCourse.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 14/5/23.
//

import Foundation
import GlassRoomAPI

public enum GeneralCourse: Hashable, Identifiable {
    case course(String)
    case allTeaching
    case allEnrolled
    case group(String)

    public var id: String {
        switch self {
        case .course(let id):
            return id
        case .allTeaching:
            return "allTeaching"
        case .allEnrolled:
            return "allEnrolled"
        case .group(let group):
            return group
        }
    }
    
    public var caseName: String {
        switch self {
        case .course(_):
            return "Course"
        case .allTeaching:
            return "Teaching Course"
        case .allEnrolled:
            return "Enrolled Course"
        case .group(_):
            return "Group"
        }
    }

    public static func == (lhs: GeneralCourse, rhs: GeneralCourse) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
