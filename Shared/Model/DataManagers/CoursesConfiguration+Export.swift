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

        return decodeSelf
    }

    public func loadIntoSelf(config: GlobalCoursesDataManager.CoursesConfiguration) {
        // copy the config's data into self
    }
}
