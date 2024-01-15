//
//  FileManager.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 13/5/23.
//

import Foundation
import GlassRoomTypes

public enum FileSystem {
    public static var currentUserEmail: String?

    public enum FileName {
        case courses
        case courseConfigurations
        case announcements(String)
        case courseWorks(String)
        case courseMaterials(String)
        case submissions(String, String)
        case studentReferences(String)
        case teacherReferences(String)
        case userProfiles

        public var fileName: String {
            guard let currentUserEmail = FileSystem.currentUserEmail else {
                fatalError("Could not save cache")
            }
            switch self {
            case .courses: return "\(currentUserEmail)/courseCache.json"
            case .courseConfigurations: return "\(currentUserEmail)/courseConfigurations.json"
            case .announcements(let courseId): return "\(currentUserEmail)/courses/\(courseId)/announcements.json"
            case .courseWorks(let courseId): return "\(currentUserEmail)/courses/\(courseId)/courseWorks/courseWorks.json"
            case .courseMaterials(let courseId): return "\(currentUserEmail)/courses/\(courseId)/courseMaterials.json"
            case .submissions(let courseId, let courseWorkId): return "\(currentUserEmail)/courses/\(courseId)/courseWorks/\(courseWorkId)_submissions.json"
            case .studentReferences(let courseId): return "\(currentUserEmail)/courses/\(courseId)/studentReferences.json"
            case .teacherReferences(let courseId): return "\(currentUserEmail)/courses/\(courseId)/teacherReferences.json"
            case .userProfiles: return "\(currentUserEmail)/userProfiles.json"
            }
        }
    }

    /// Reads a type from a file
    public static func read<T: Decodable>(_ type: T.Type, from file: FileName) -> T? {
        let filename = getDocumentsDirectory().appendingPathComponent(file.fileName)
        if let data = try? Data(contentsOf: filename) {
            if let values = try? JSONDecoder().decode(T.self, from: data) {
                return values
            }
        }

        return nil
    }

    /// Writes a type to a file
    public static func write<T: Encodable>(_ value: T, to file: FileName, error onError: @escaping (Error) -> Void = { _ in }) {
        var encoded: Data

        do {
            encoded = try JSONEncoder().encode(value)
        } catch {
            onError(error)
            return
        }

        let filename = getDocumentsDirectory().appendingPathComponent(file.fileName)
        if file.fileName.contains("/") {
            try? FileManager.default.createDirectory(atPath: filename.deletingLastPathComponent().path,
                                                     withIntermediateDirectories: true,
                                                     attributes: nil)
        }
        do {
            try encoded.write(to: filename)
            return
        } catch {
            // failed to write file – bad permissions, bad filename,
            // missing permissions, or more likely it can't be converted to the encoding
            onError(error)
        }
    }

    /// Checks if a file exists at a path
    public static func exists(file: FileName) -> Bool {
        let path = getDocumentsDirectory().appendingPathComponent(file.fileName)
        return FileManager.default.fileExists(atPath: path.relativePath)
    }

    /// Returns the URL of the path
    public static func path(file: FileName) -> URL {
        getDocumentsDirectory().appendingPathComponent(file.fileName)
    }

    /// Gets the documents directory
    public static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        Log.info("Documents directory at \(paths[0])")
        return paths[0]
    }
}

public extension URL {
    /// The attributes of a url
    var attributes: [FileAttributeKey: Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            Log.error("FileAttribute error: \(error)")
        }
        return nil
    }

    /// The file size of the url
    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }

    /// The file size of the url as a string
    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }

    /// The date of creation of the file
    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
}

public extension Array {
    func mergedWith(other: [Element],
                    isSame: (Element, Element) -> Bool,
                    isBefore: (Element, Element) -> Bool) -> [Element] {
        let mergedArray = self + other
        let sortedArray = mergedArray.sorted(by: isBefore)
        var result: [Element] = []

        for element in sortedArray {
            if !result.contains(where: { isSame($0, element) }) {
                result.append(element)
            }
        }

        return result
    }

    mutating func mergeWith(other: [Element],
                            isSame: (Element, Element) -> Bool,
                            isBefore: (Element, Element) -> Bool) {
        self = mergedWith(other: other, isSame: isSame, isBefore: isBefore)
    }
}
