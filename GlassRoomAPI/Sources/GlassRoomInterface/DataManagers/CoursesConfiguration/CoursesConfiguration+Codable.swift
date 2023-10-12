//
//  CoursesConfiguration+Codable.swift
//
//
//  Created by Kai Quan Tay on 12/10/23.
//

import SwiftUI

extension CoursesConfiguration: Codable {
    // MARK: Codable
    public enum Keys: CodingKey, CaseIterable {
        case replacedCourseNames, courseGroups, archive, customColors, customIcons

        public var description: String {
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

    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        self.init(
            replacedCourseNames: (try? container.decode([NameReplacement].self,
                                                        forKey: .replacedCourseNames)) ?? [],
            courseGroups: (try? container.decode([CourseGroup].self,
                                                 forKey: .courseGroups)) ?? [],
            archive: try? container.decode((CourseGroup?).self, forKey: .archive),
            customColors: (try? container.decode([String: Color].self,
                                                 forKey: .customColors)) ?? [:],
            customIcons: (try? container.decode([String: String].self,
                                                forKey: .customIcons)) ?? [:]
        )

        groupIdMap = [:]
        for group in courseGroups {
            groupIdMap[group.id] = group
        }
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
