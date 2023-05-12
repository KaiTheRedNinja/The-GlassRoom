//
//  GradebookSettings.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public struct GradebookSettings: Codable {
    public var calculationType: CalculationType
    public var displaySetting: DisplaySetting
    public var gradeCategories: [GradeCategory]
}
