//
//  TypeExtensions.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 22/6/23.
//

import Foundation
import GlassRoomTypes

extension Course: Identifiable, Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
