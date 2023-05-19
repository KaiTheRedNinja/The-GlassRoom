//
//  UPName.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public struct UPName: Codable { // not called Name since Name already exists, UPName stands for UserProfileName
    public var givenName: String
    public var familyName: String?
    public var fullName: String
}
