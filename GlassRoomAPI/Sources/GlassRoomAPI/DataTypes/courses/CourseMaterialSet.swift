//
//  CourseMaterialSet.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public struct CourseMaterialSet: Codable {
    public var title: String
    public var materials: [CourseMaterial]
}
