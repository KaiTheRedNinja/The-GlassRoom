//
//  CoursesConfiguration+Export.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 27/7/23.
//

import Foundation
import SwiftUI

extension GlobalCoursesDataManager.CoursesConfiguration {
    public func exportURL() -> URL {
        var encoded: Data!
        do {
            encoded = try JSONEncoder().encode(self)
        } catch {
            fatalError(error.localizedDescription)
        }
        guard let encoded,
              let compressed = try? (encoded as NSData).compressed(using: .lzfse)
        else { fatalError() }
        let base64 = compressed.base64EncodedString()

        if let original = String(data: encoded, encoding: .utf8) {
            print(original)
            print(original.count)
            print(compressed.length)
            print(base64.count)
        }

        return URL(string: "grconfig://\(base64)")!
    }

    public func loadFromUrl(url: URL) -> GlobalCoursesDataManager.CoursesConfiguration? {
        let string = url.absoluteString.replacingOccurrences(of: "grconfig://", with: "")

        guard let stringData = string.data(using: .utf8),
              let data = Data(base64Encoded: stringData),
              let uncompressed = try? (data as NSData).decompressed(using: .lzfse)
        else {
            print("Could not get string data, data, or uncompressed")
            return nil
        }

        guard let decodeSelf = try? JSONDecoder().decode(
            GlobalCoursesDataManager.CoursesConfiguration.self,
            from: uncompressed as Data)
        else {
            print("Could not decode")
            return nil
        }

        // clean the decodeSelf to remove classes that the user doesn't have, and change the IDs of the course groups
        let courseManager = GlobalCoursesDataManager.global
        for index in 0..<decodeSelf.courseGroups.count {
            var group = decodeSelf.courseGroups[index]
            group.courses = group.courses.filter({ courseManager.courseIdMap.keys.contains($0) })
            group.id = UUID().uuidString
            decodeSelf.courseGroups[index] = group
        }

        if var archive = decodeSelf.archive {
            archive.courses = archive.courses.filter({ courseManager.courseIdMap.keys.contains($0) })
            archive.id = UUID().uuidString
            decodeSelf.archive = archive
        }

        decodeSelf.customColors = decodeSelf.customColors.filter({ courseManager.courseIdMap.keys.contains($0.key) })
        decodeSelf.customIcons = decodeSelf.customIcons.filter({ courseManager.configuration.customIcons.keys.contains($0.key) })

        return decodeSelf
    }

    enum LoadStyle: CaseIterable {
        case replace
        case append

        var description: String {
            switch self {
            case .replace: "Replace"
            case .append: "Append"
            }
        }
    }

    public func loadIntoSelf(
        config: GlobalCoursesDataManager.CoursesConfiguration,
        fields: [GlobalCoursesDataManager.CoursesConfiguration.Keys: LoadStyle]
    ) {
        // copy the config's data into self
        for (field, style) in fields {
            switch field {
            case .replacedCourseNames:
                switch style {
                case .replace: self.replacedCourseNames = config.replacedCourseNames
                case .append: self.replacedCourseNames += config.replacedCourseNames
                }
            case .courseGroups:
                switch style {
                case .replace: self.courseGroups = config.courseGroups
                case .append: self.courseGroups += config.courseGroups
                }
            case .archive:
                switch style {
                case .replace: self.archive = config.archive
                case .append:
                    self.archive?.courses += config.archive?.courses ?? []
                    if self.archive == nil {
                        self.archive = config.archive
                    }
                }
            case .customColors:
                switch style {
                case .replace: self.customColors = config.customColors
                case .append: config.customColors.forEach({ self.customColors[$0.key] = $0.value })
                }
            case .customIcons:
                switch style {
                case .replace: self.customIcons = config.customIcons
                case .append: config.customIcons.forEach({ self.customIcons[$0.key] = $0.value })
                }
            }
        }
    }
}
