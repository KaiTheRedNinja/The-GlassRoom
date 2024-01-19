//
//  CoursesConfiguration+Access.swift
//
//
//  Created by Kai Quan Tay on 12/10/23.
//

import SwiftUI
import GlassRoomTypes

extension CoursesConfiguration {
    /// Generates a seemingly random color for a string
    public func colorFor(_ courseId: String) -> Color {
        if let customColor = customColors[courseId] {
            return customColor
        }

        var total: Int = 0
        for u in courseId.unicodeScalars {
            total += Int(UInt32(u))
        }

        srand48(total * 47)
        let r = CGFloat(drand48())

        srand48(total)
        let g = CGFloat(drand48())

        srand48(total / 47)
        let b = CGFloat(drand48())

        return Color(red: r, green: g, blue: b, opacity: 1)
    }

    public func iconFor(_ courseId: String) -> String {
        if let customIcon = customIcons[courseId] {
            return customIcon
        }

        // TODO: Semirandom icon
        return "person.2.fill"
    }

    public func nameFor(_ course: Course) -> String {
        // determine if it has been directly renamed already
        if let rename = renamedCourses[course.id] {
            return rename
        }

        return course.name
    }
}
