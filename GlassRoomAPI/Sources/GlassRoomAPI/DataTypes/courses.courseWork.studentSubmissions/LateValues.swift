//
//  LateValues.swift
//  
//
//  Created by Kai Quan Tay on 15/5/23.
//

import Foundation

public enum LateValues: String, Codable {
    case late_values_unspecified = "LATE_VALUES_UNSPECIFIED"
    case late_only = "LATE_ONLY"
    case not_late_only = "NOT_LATE_ONLY"
}
