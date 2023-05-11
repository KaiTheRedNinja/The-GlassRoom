//
//  UserProfile.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public struct UserProfile {
    public var id: String
    public var name: UPName
    public var emailAddress: String
    public var photoUrl: String
    public var permissions: [GlobalPermission]
    public var verifiedTeacher: Bool
}
