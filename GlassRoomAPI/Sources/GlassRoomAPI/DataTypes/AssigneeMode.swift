//
//  AssigneeMode.swift
//  GlassRoomAPIProtocol
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

public enum AssigneeMode: String, Codable {
    case assignee_mode_unspecified = "ASSIGNEE_MODE_UNSPECIFIED"
    case all_students = "ALL_STUDENTS"
    case individual_students = "INDIVIDUAL_STUDENTS"
}
