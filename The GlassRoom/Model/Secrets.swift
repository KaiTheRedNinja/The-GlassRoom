//
//  Secrets.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 12/5/23.
//

import Foundation

protocol SecretProtocol {
    static func getGoogleClientID() -> String
}

extension SecretProtocol {
    static func getGoogleClientID() -> String {
        fatalError("Please create your own Secrets file")
    }
}

enum Secrets: SecretProtocol {}
