//
//  CalculationType.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public enum CalculationType: String, Codable {
    case calculation_type_unspecified = "CALCULATION_TYPE_UNSPECIFIED"
    case total_points = "TOTAL_POINTS"
    case weighted_categories = "WEIGHTED_CATEGORIES"
}
