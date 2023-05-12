//
//  ModifyIndividualStudentsOptions.swift
//  GlassRoomAPIProtocol
//
//  Created by Kai Quan Tay on 11/5/23.
//

public struct ModifyIndividualStudentsOptions: Codable {
    public var addStudentIds: [String]
    public var removeStudentIds: [String]
}
