//
//  GuardianInvitation.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public struct GuardianInvitation {
    public var studentId: String
    public var invitationId: String
    public var invitedEmailAddress: String
    public var state: GuardianInvitationState
    public var creationTime: String
}
