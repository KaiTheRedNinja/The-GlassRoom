//
//  DueDate.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public struct DueDate: Codable { // Not called Date since thats ambiguous
    public var year: Int
    public var month: Int
    public var day: Int
    
    public init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }
}
