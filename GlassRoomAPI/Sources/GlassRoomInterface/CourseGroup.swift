//
//  CourseGroup.swift
//
//
//  Created by Kai Quan Tay on 12/10/23.
//

import Foundation
import GlassRoomTypes

public struct CourseGroup: Codable, Identifiable, Equatable {
    public var id = UUID().uuidString
    public var groupName: String
    public var groupType: Course.CourseType
    public var courses: [String]

    public var isArchive: Bool { id == CourseGroup.archiveId }

    public static let archiveId = "Archive"

    public init(
        id: String = UUID().uuidString,
        groupName: String,
        groupType: Course.CourseType,
        courses: [String]
    ) {
        self.id = id
        self.groupName = groupName
        self.groupType = groupType
        self.courses = courses
    }
}
