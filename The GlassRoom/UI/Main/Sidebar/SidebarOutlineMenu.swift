//
//  SidebarOutlineMenu.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 13/5/23.
//

import SwiftUI
import GlassRoomAPI
import GlassRoomInterface

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
        guard let item = item as? GeneralCourse else { return }

        let isArchived = CoursesConfiguration.global.archive?.courses.contains(item.id) ?? false

        switch item {
        case .group(let id):
            if id != CourseGroup.archiveId {
                items = [
                    menuItem("Rename Group", action: #selector(renameGroupOrCourse)),
                    menuItem("\(isArchived ? "Unarchive" : "Archive") Group", action: #selector(archive)),
                    menuItem("Remove Group", action: #selector(deleteGroup))
                ]
            } else {
                items = []
            }
        case .allEnrolled, .allTeaching:
            items = []
        default:
            items = [
                menuItem("Rename Course", action: #selector(renameGroupOrCourse)),
                menuItem("\(isArchived ? "Unarchive" : "Archive") Course", action: #selector(archive)),
                menuItem("Show Cache In Finder", action: #selector(showCacheInFinder))
            ]
        }
    }

    @objc
    func renameGroupOrCourse() {
        guard let item = item as? GeneralCourse else { return }
        switch item {
        case .group(let string):
            outlineView.renamedGroup?.wrappedValue = string
        case .course(let string):
            outlineView.renamedCourse?.wrappedValue = string
        default: return
        }
    }

    @objc
    func deleteGroup() {
        guard let item = item as? GeneralCourse else { return }
        switch item {
        case .group(let string):
            outlineView.courseGroups.removeAll(where: { $0.id == string })
            outlineView.updateGroups?(outlineView.courseGroups)
        default: return
        }
    }

    @objc
    func archive() {
        guard let item = item as? GeneralCourse else { return }
        let config = CoursesConfiguration.global
        config.archive(item: item)
        config.saveToFileSystem()
    }

    @objc
    func showCacheInFinder() {
        guard let item = item as? GeneralCourse else { return }
        switch item {
        case .course(let string):
            let file = FileSystem.FileName.courseWorks(string)
            let path = FileSystem.getDocumentsDirectory()
                .appendingPathComponent(file.fileName)
                .deletingLastPathComponent().deletingLastPathComponent()
            NSWorkspace.shared.open(path)
        default: return
        }
    }
}
