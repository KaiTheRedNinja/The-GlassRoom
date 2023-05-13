//
//  DisplaySetting.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public enum DisplaySetting: String, Codable {
    case display_setting_unspecified = "DISPLAY_SETTING_UNSPECIFIED"
    case show_overall_grade = "SHOW_OVERALL_GRADE"
    case hide_overall_grade = "HIDE_OVERALL_GRADE"
    case show_teachers_only = "SHOW_TEACHERS_ONLY"
}
