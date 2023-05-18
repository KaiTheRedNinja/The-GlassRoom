//
//  GradeHistory.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public struct GradeHistory: Codable {
    public var pointsEarned: Double
    public var maxPoints: Double
    public var gradeTimestamp: String
    public var actorUserId: String
    public var gradeChangeType: GradeChangeType
}
