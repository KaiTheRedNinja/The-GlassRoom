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

    public static func == (lhs: GeneralCourse, rhs: GeneralCourse) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
