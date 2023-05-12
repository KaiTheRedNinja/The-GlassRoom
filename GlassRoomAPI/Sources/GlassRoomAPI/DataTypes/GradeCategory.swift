//
//  GradeCategory.swift
//  GlassRoomAPIProtocol
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

public struct GradeCategory: Codable {
    public var id: String
    public var name: String
    public var weight: Int
    public var defaultGradeDenominator: Int
}
