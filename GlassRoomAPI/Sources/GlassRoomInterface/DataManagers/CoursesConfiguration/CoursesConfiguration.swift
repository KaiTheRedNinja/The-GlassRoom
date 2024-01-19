//
//  GlobalCoursesDataManager+Configuration.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 16/5/23.
//

import SwiftUI
import GlassRoomAPI
import GlassRoomTypes

public final class CoursesConfiguration: ObservableObject, Identifiable {
    public var id = UUID()

    @Published public var courseGroups: [CourseGroup] {
        didSet {
            groupIdMap = [:]
            for group in courseGroups {
                groupIdMap[group.id] = group
            }
        }
    }
    @Published public var archive: CourseGroup?

    @Published public var renamedCourses: [String: String]
    @Published public var customColors: [String: Color]
    @Published public var customIcons: [String: String]

    @Published public internal(set) var groupIdMap: [String: CourseGroup] = [:]

    internal init(
        courseGroups: [CourseGroup] = [],
        archive: CourseGroup? = nil,
        renamedCourses: [String: String] = [:],
        customColors: [String: Color] = [:],
        customIcons: [String: String] = [:]
    ) {
        self.renamedCourses = renamedCourses
        self.courseGroups = courseGroups
        self.archive = archive
        self.customColors = customColors
        self.customIcons = customIcons

        groupIdMap = [:]
        for group in courseGroups {
            groupIdMap[group.id] = group
        }
    }

    public static var global: CoursesConfiguration = .loadedFromFileSystem()
    private static func loadedFromFileSystem() -> CoursesConfiguration {
        // if the file exists in CourseCache
        if FileSystem.exists(file: .courseConfigurations),
           let savedConfig = FileSystem.read(CoursesConfiguration.self, from: .courseConfigurations) {
            return savedConfig
        }
        let newInstance = CoursesConfiguration()
        return newInstance
    }

    public func saveToFileSystem() {
        FileSystem.write(self, to: .courseConfigurations) { error in
            Log.error("Error writing: \(error.localizedDescription)")
        }
    }
}

extension String: Identifiable {
    public var id: String { self }
}
