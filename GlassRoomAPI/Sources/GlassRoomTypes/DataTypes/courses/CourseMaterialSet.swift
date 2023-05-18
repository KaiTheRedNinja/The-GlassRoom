//
//  CourseMaterialSet.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

@available(*, deprecated, message: "This is no longer used")
public struct CourseMaterialSet: Codable {
    public var title: String
    public var materials: [CourseMaterial]
}
