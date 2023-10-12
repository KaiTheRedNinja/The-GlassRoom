//
//  GlobalCoursesDataManager+Configuration.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 16/5/23.
//

import SwiftUI
import GlassRoomAPI
import GlassRoomTypes
import GlassRoomInterface

class CoursesConfiguration: ObservableObject, Codable, Identifiable {
    var id = UUID()

    @Published var replacedCourseNames: [NameReplacement]
    @Published var courseGroups: [CourseGroup] {
        didSet {
            groupIdMap = [:]
            for group in courseGroups {
                groupIdMap[group.id] = group
            }
        }
    }
    @Published var archive: CourseGroup?
    @Published var customColors: [String: Color]
    @Published var customIcons: [String: String]

    @Published var groupIdMap: [String: CourseGroup] = [:]

    private init(
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

    static var global: CoursesConfiguration = .loadedFromFileSystem()
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

    func saveToFileSystem() {
        FileSystem.write(self, to: .courseConfigurations) { error in
            Log.error("Error writing: \(error.localizedDescription)")
        }
    }

    /// Generates a seemingly random color for a string
    func colorFor(_ courseId: String) -> Color {
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

    func iconFor(_ courseId: String) -> String {
        if let customIcon = customIcons[courseId] {
            return customIcon
        }

        // TODO: Semirandom icon
        return "person.2.fill"
    }

    func nameFor(_ courseName: String) -> String {
        // change all the replacement strings
        var mutableCourseName = courseName
        for replacedCourseName in replacedCourseNames {
            mutableCourseName.removingRegexMatches(pattern: replacedCourseName.matchString,
                                                   replaceWith: replacedCourseName.replacement)
        }
        return mutableCourseName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: Archive, groups
    func archive(item: GeneralCourse) {
        var isArchived = archive?.courses.contains(item.id) ?? false

        if isArchived {
            archive?.courses.removeAll(where: { $0.id == item.id })
        } else {
            var archivingCourses: [String] = []

            switch item {
            case .group(let string):
                // archive all courses in the group
                guard let groupIndex = courseGroups.firstIndex(where: { $0.id == string })
                else { return }
                archivingCourses = courseGroups.remove(at: groupIndex).courses
            case .course(let string):
                // archive that course
                print("Archiving course \(string)")
                archivingCourses = [string]
            default: return
            }
            if archive == nil {
                archive = .init(
                    id: CourseGroup.archiveId,
                    groupName: CourseGroup.archiveId,
                    groupType: .enrolled,
                    courses: archivingCourses)
            } else {
                archive?.courses.append(contentsOf: archivingCourses)
                objectWillChange.send()
            }
            saveToFileSystem()
        }
    }
    func archivePRO(item: String) {
        var archivingCourses: [String] = []
        print("Archiving course \(item)")
        archivingCourses = [item]
        if archive == nil {
            archive = .init(
                id: item,
                groupName: "Archive",
                groupType: .enrolled,
                courses: archivingCourses)
        } else {
            archive?.courses.append(contentsOf: archivingCourses)
            objectWillChange.send()
        }
        saveToFileSystem()
    }

    // MARK: Codable
    enum Keys: CodingKey, CaseIterable {
        case replacedCourseNames, courseGroups, archive, customColors, customIcons

        var description: String {
            switch self {
            case .replacedCourseNames: "Course Name Replacement"
            case .courseGroups: "Course Groups"
            case .archive: "Archives"
            case .customColors: "Course Colors"
            case .customIcons: "Course Icons"
            }
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(replacedCourseNames, forKey: .replacedCourseNames)
        try container.encode(courseGroups, forKey: .courseGroups)
        try container.encode(archive, forKey: .archive)
        try container.encode(customColors, forKey: .customColors)
        try container.encode(customIcons, forKey: .customIcons)
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.replacedCourseNames = (try? container.decode([NameReplacement].self,
                                                          forKey: .replacedCourseNames)) ?? []
        self.courseGroups = (try? container.decode([CourseGroup].self,
                                                   forKey: .courseGroups)) ?? []
        self.archive = try? container.decode((CourseGroup?).self, forKey: .archive)
        self.customColors = (try? container.decode([String: Color].self,
                                                   forKey: .customColors)) ?? [:]
        self.customIcons = (try? container.decode([String: String].self,
                                                  forKey: .customIcons)) ?? [:]

        groupIdMap = [:]
        for group in courseGroups {
            groupIdMap[group.id] = group
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

extension Color: Codable {
    enum CodingKeys: String, CodingKey {
        case red, green, blue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let r = try container.decode(Double.self, forKey: .red)
        let g = try container.decode(Double.self, forKey: .green)
        let b = try container.decode(Double.self, forKey: .blue)

        self.init(red: r, green: g, blue: b)
    }

    public func encode(to encoder: Encoder) throws {
        guard let colorComponents = self.colorComponents else {
            return
        }

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(colorComponents.red, forKey: .red)
        try container.encode(colorComponents.green, forKey: .green)
        try container.encode(colorComponents.blue, forKey: .blue)
    }

    var colorComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        #if os(macOS)
        NSColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        #else
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        #endif

        return (r, g, b, a)
    }
}

struct NameReplacement: Codable, Identifiable, Equatable {
    var id = UUID()
    var matchString: String
    var replacement: String
}

struct CourseGroup: Codable, Identifiable, Equatable {
    var id = UUID().uuidString
    var groupName: String
    var groupType: Course.CourseType
    var courses: [String]

    var isArchive: Bool { id == CourseGroup.archiveId }

    static let archiveId = "Archive"
}
