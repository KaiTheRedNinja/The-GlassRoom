//
//  Registration.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public struct Registration {
    public var registrationId: String
    public var feed: Feed
    public var expiryTime: String
    public var cloudPubsubTopic: CloudPubsubTopic
}
