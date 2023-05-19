//
//  MultipleChoiceQuestion.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public struct MultipleChoiceQuestion: Codable {
    public var choices: [String]
    
    public init(choices: [String]) {
        self.choices = choices
    }
}
