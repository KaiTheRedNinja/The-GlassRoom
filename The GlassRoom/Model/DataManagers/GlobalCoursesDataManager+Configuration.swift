//
//  GlobalCoursesDataManager+Configuration.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 16/5/23.
//

import SwiftUI

extension GlobalCoursesDataManager {
    class CoursesConfiguration: ObservableObject, Codable {
        var replacedCourseNames: [String: String]
        var customColors: [String: Color]

        private init(replacedCourseNames: [String: String] = [:],
             customColors: [String: Color] = [:]) {
            self.replacedCourseNames = replacedCourseNames
            self.customColors = customColors
        }

        static func loadedFromFileSystem() -> CoursesConfiguration {
            // if the file exists in CourseCache
            if FileSystem.exists(file: "courseConfiguration.json"),
                let savedConfig = FileSystem.read(CoursesConfiguration.self, from: "courseConfiguration.json") {
                return savedConfig
            }
            return .init(replacedCourseNames: [:], customColors: [:])
        }

        func saveToFileSystem() {
            FileSystem.write(self, to: "courseConfiguration.json") { error in
                print("Error writing: \(error.localizedDescription)")
            }
        }

        /// Generates a seemingly random color for a string
        func colorFor(_ courseId: String) -> Color {
            if let customColor = customColors[courseId] {
                return customColor
            }

            let asciiValue = courseId.reduce(0) { partialResult, char in
                partialResult + Int(char.asciiValue ?? 0)
            }

            let redRoot = 17
            let greenRoot = 59
            let blueRoot = 83

            let redValue = Double(asciiValue%redRoot)/Double(redRoot)
            let greenValue = Double(asciiValue%greenRoot)/Double(greenRoot)
            let blueValue = Double(asciiValue%blueRoot)/Double(blueRoot)

            let redComponent = redValue
            let greenComponent = greenValue
            let blueComponent = blueValue

            return .init(red: redComponent, green: greenComponent, blue: blueComponent)
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

        NSColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)

        return (r, g, b, a)
    }
}
