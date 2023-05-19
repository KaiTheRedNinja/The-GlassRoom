//
//  TimeOfDay.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public struct TimeOfDay: Codable {
    public var hours: Int?
    public var minutes: Int?
    public var seconds: Int?
    public var nanos: Int?
    
    public init(hours: Int? = nil, minutes: Int? = nil, seconds: Int? = nil, nanos: Int? = nil) {
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        self.nanos = nanos
    }
}
