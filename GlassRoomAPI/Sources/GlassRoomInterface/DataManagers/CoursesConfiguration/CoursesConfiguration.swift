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

    @Published public var replacedCourseNames: [NameReplacement]
    @Published public var courseGroups: [CourseGroup] {
        didSet {
            groupIdMap = [:]
            for group in courseGroups {
                groupIdMap[group.id] = group
            }
        }
    }
    @Published public var archive: CourseGroup?
    @Published public var customColors: [String: Color]
    @Published public var customIcons: [String: String]

    @Published public var groupIdMap: [String: CourseGroup] = [:]

    internal init(
        replacedCourseNames: [NameReplacement] = [],
        courseGroups: [CourseGroup] = [],
        archive: CourseGroup?,
        customColors: [String: Color] = [:],
        customIcons: [String: String] = [:]
    ) {
        self.replacedCourseNames = replacedCourseNames
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
        let newInstance = CoursesConfiguration(replacedCourseNames: [],
                                               courseGroups: [],
                                               archive: nil,
                                               customColors: [:])
        return newInstance
    }

    public func saveToFileSystem() {
        FileSystem.write(self, to: .courseConfigurations) { error in
            Log.error("Error writing: \(error.localizedDescription)")
        }
    }
}

extension String {
    mutating func removingRegexMatches(pattern: String, replaceWith: String = "") {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: count)
            self = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replaceWith)
        } catch { return }
    }
}

extension String: Identifiable {
    public var id: String { self }
}

public struct NameReplacement: Codable, Identifiable, Equatable {
    public var id = UUID()
    public var matchString: String
    public var replacement: String

    public init(id: UUID = UUID(), matchString: String, replacement: String) {
        self.id = id
        self.matchString = matchString
        self.replacement = replacement
    }
}
