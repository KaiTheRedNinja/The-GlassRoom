//
//  File.swift
//  
//
//  Created by Kai Quan Tay on 16/5/23.
//

import Foundation

extension GlassRoomAPI.GDDriveDetails: GlassRoomGettable {
    public typealias GetPathParameters = FileIDPathParameters
    public typealias GetQueryParameters = GetPropertiesQueryParameters
    public typealias GetRequestData = VoidStringCodable
    public typealias GetResponseData = NameResponseData

    public static var apiGettable: String = "https://www.googleapis.com/drive/v3/files/{fileId}"

    public struct FileIDPathParameters: StringCodable {
        public var fileId: String

        public init(fileId: String) {
            self.fileId = fileId
        }

        public func stringDictionaryEncoded() -> [String : String] {
            ["fileId": fileId]
        }
    }

    public struct GetPropertiesQueryParameters: StringCodable {
        public var fields: [String]

        public init(fields: [String]) {
            self.fields = fields
        }

        public func stringDictionaryEncoded() -> [String : String] {
            ["fields": fields.joined(separator: ",")]
        }
    }

    public struct NameResponseData: Codable {
        public var name: String?

        public init(name: String?) {
            self.name = name
        }
    }
}
