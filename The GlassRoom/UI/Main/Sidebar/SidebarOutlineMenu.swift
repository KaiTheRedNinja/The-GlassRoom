//
//  SidebarOutlineMenu.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 13/5/23.
//

import SwiftUI
import GlassRoomAPI

/// A subclass of `NSMenu` implementing the contextual menu for the project navigator
final class SidebarOutlineMenu: NSMenu {
    var outlineView: SidebarOutlineViewController

    var item: Any?

    init(sender: SidebarOutlineViewController) {
        outlineView = sender
        super.init(title: "Options")
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Updates the menu for the selected item and hides it if no item is provided.
    override func update() {
        removeAllItems()
        setupMenu()
    }
    
    /// Creates a `NSMenuItem` depending on the given arguments
    /// - Parameters:
    ///   - title: The title of the menu item
    ///   - action: A `Selector` or `nil` of the action to perform.
    ///   - key: A `keyEquivalent` of the menu item. Defaults to an empty `String`
    /// - Returns: A `NSMenuItem` which has the target `self`
    private func menuItem(_ title: String, action: Selector?, key: String = "") -> NSMenuItem {
        let mItem = NSMenuItem(title: title, action: action, keyEquivalent: key)
        mItem.target = self

        return mItem
    }

    /// Setup the menu and disables certain items when `isFile` is false
    /// - Parameter isFile: A flag indicating that the item is a file instead of a directory
    private func setupMenu() {
        guard item is Course else { return }
        let changeColor = menuItem("Change Color", action: #selector(changeColor))

        items = [
            changeColor
        ]
    }

    @objc
    func changeColor() {
        guard let item = item as? Course else { return }
        print("Changing color")
        outlineView.colorChangingCourse?.wrappedValue = item
    }
}
