//
//  Shortcuts.swift
//  The GlassRoom
//
//  Created by Tristan Chay on 23/8/23.
//

import Foundation
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let reloadSidebar = Self("reloadSidebar", default: .init(.r, modifiers: [.command, .shift]))
    static let reloadCoursePosts = Self("reloadCoursePosts", default: .init(.r, modifiers: .command))
    
    static let nextTab = Self("nextTab"/*, default: .init(.rightBracket, modifiers: [.command, .shift])*/)
    static let previousTab = Self("previousTab"/*, default: .init(.leftBracket, modifiers: [.command, .shift])*/)
    
    static let toggleTabBar = Self("toggleTabBar", default: .init(.b, modifiers: [.command, .shift]))
    
    static let openUniversalSearch = Self("openUniversalSearch", default: .init(.o, modifiers: [.command, .shift]))
}
