//
//  SidebarOutlineViewController.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 13/5/23.
//

import SwiftUI
import GlassRoomAPI

/// A `NSViewController` that handles the **ProjectNavigatorView** in the **NavigatorSideabr**.
///
/// Adds a ``outlineView`` inside a ``scrollView`` which shows the folder structure of the
/// currently open project.
final class SidebarOutlineViewController: NSViewController {

    var scrollView: NSScrollView!
    var outlineView: NSOutlineView!

    /// This helps determine whether or not to send an `openTab` when the selection changes.
    /// Used b/c the state may update when the selection changes, but we don't necessarily want
    /// to open the file a second time.
    private var shouldSendSelectionUpdate: Bool = true

    let categories: [String] = [
        "Courses",
        "IDK man",
        "Debug stuff"
    ]

    var selectedCourse: Binding<Course?>? = nil
    var courses: [Course] = []

    /// Setup the ``scrollView`` and ``outlineView``
    override func loadView() {
        self.scrollView = NSScrollView()
        self.scrollView.hasVerticalScroller = true
        self.view = scrollView

        self.outlineView = NSOutlineView()
        self.outlineView.dataSource = self
        self.outlineView.delegate = self
        self.outlineView.autosaveExpandedItems = true
//        self.outlineView.autosaveName =
        self.outlineView.headerView = nil
        self.outlineView.menu = SidebarOutlineMenu(sender: outlineView)
        self.outlineView.menu?.delegate = self
        self.outlineView.doubleAction = #selector(onItemDoubleClicked)

        let column = NSTableColumn(identifier: .init(rawValue: "Cell"))
        column.title = "Cell"
        outlineView.addTableColumn(column)

        outlineView.setDraggingSourceOperationMask(.move, forLocal: false)
        outlineView.registerForDraggedTypes([.fileURL])

        scrollView.documentView = outlineView
        scrollView.contentView.automaticallyAdjustsContentInsets = false
        scrollView.contentView.contentInsets = .init(top: 10, left: 0, bottom: 0, right: 0)
        scrollView.scrollerStyle = .overlay
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true

        outlineView.expandItem(outlineView.item(atRow: 0))
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    /// Expand or collapse the folder on double click
    @objc
    private func onItemDoubleClicked() {
        // TODO: Expand a category if it is double clicked
    }
}

// MARK: - NSOutlineViewDataSource

extension SidebarOutlineViewController: NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        guard let item else {
            return categories.count
        }
        if item is Course {
            return 0
        } else if let item = item as? String {
            switch item {
            case "Courses": return courses.count
            default: return 0
            }
        }

        return 0
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        guard let item else {
            return categories[index]
        }
        if item is Course {
            return 0
        } else if let item = item as? String {
            switch item {
            case "Courses": return courses[index]
            default: return 0
            }
        }

        return 0
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let item = item as? String, categories.contains(item) {
            return true
        }
        return false
    }
}

// MARK: - NSOutlineViewDelegate

extension SidebarOutlineViewController: NSOutlineViewDelegate {
    func outlineView(
        _ outlineView: NSOutlineView,
        shouldShowCellExpansionFor tableColumn: NSTableColumn?,
        item: Any
    ) -> Bool {
        true
    }

    func outlineView(_ outlineView: NSOutlineView, shouldShowOutlineCellForItem item: Any) -> Bool {
        true
    }

    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let tableColumn else { return nil }

        let frameRect = NSRect(x: 0,
                               y: 0,
                               width: tableColumn.width,
                               height: self.outlineView(outlineView, heightOfRowByItem: item))

        if let item = item as? String {
//            let textView = NSTextView(frame: frameRect)
//            textView.string = item
            let contentView = NSHostingView(rootView: {
                CourseCategoryHeaderView(name: item)
                    .frame(maxWidth: frameRect.width, maxHeight: frameRect.height)
            }())
            return contentView
        }
        if let item = item as? Course {
            let contentView = NSHostingView(rootView: {
                CourseView(course: item)
                    .frame(maxWidth: frameRect.width, maxHeight: frameRect.height)
            }())
            contentView.frame = frameRect
            return contentView
        }

        print("Item \(item) did not match String or Course")
        return nil // TODO: return the view
    }

    func outlineViewSelectionDidChange(_ notification: Notification) {
        let row = outlineView.selectedRow
        print("Selection changed! \(row)")
        if row == -1 {
            selectedCourse?.wrappedValue = nil
        } else {
            if let item = outlineView.item(atRow: row) as? Course {
                print("Changing wrapped value")
                selectedCourse?.wrappedValue = item
            } else {
                selectedCourse?.wrappedValue = nil
            }
        }
    }

    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        22
    }

    func outlineViewItemDidExpand(_ notification: Notification) {}

    func outlineViewItemDidCollapse(_ notification: Notification) {}
}

// MARK: - NSMenuDelegate

extension SidebarOutlineViewController: NSMenuDelegate {

    /// Once a menu gets requested by a `right click` setup the menu
    ///
    /// If the right click happened outside a row this will result in no menu being shown.
    /// - Parameter menu: The menu that got requested
    func menuNeedsUpdate(_ menu: NSMenu) {
        let row = outlineView.clickedRow
        guard let menu = menu as? SidebarOutlineMenu else { return }

        if row == -1 {
            menu.item = nil
        } else {
            if let item = outlineView.item(atRow: row) {
                menu.item = item
            } else {
                menu.item = nil
            }
        }
        menu.update()
    }
}
