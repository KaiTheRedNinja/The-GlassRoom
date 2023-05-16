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

    var selectedCourse: Binding<GeneralCourse?>? = nil
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
        self.outlineView.menu = SidebarOutlineMenu(sender: self)
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

        outlineView.expandItem(outlineView.item(atRow: 1)) // 0 is teachers, 1 is students
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
            return Course.CourseType.allCases.count
        }
        if item is Course {
            return 0
        } else if let item = item as? Course.CourseType {
            return courses.filter({ $0.courseType == item }).count
        }

        return 0
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        guard let item else {
            return Course.CourseType.allCases[index]
        }
        if item is Course {
            return 0
        } else if let item = item as? Course.CourseType {
            return courses.filter({ $0.courseType == item })[index]
        }

        return 0
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let item = item as? Course.CourseType, Course.CourseType.allCases.contains(item) {
            return true
        }
        return false
    }

    func updateSelection() {
        guard let item = selectedCourse?.wrappedValue else {
            outlineView.deselectRow(outlineView.selectedRow)
            return
        }

        switch item {
        case .course(let course):
            // go through the rows individually
            for rowIndex in 0..<outlineView.numberOfRows {
                guard let rowItem = outlineView.item(atRow: rowIndex) as? Course else { continue }
                if rowItem.id == course.id {
                    outlineView.selectRowIndexes(.init(integer: rowIndex), byExtendingSelection: false)
                    return
                }
            }
        case .allTeaching, .allEnrolled:
            let row = outlineView.row(forItem: item == .allTeaching ? Course.CourseType.teaching : .enrolled)
            guard row >= 0 else { return }
            outlineView.selectRowIndexes(.init(integer: row), byExtendingSelection: false)
        }

        // if nothing found, no match.
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

        if let item = item as? Course.CourseType {
            let contentView = NSHostingView(rootView: {
                CourseCategoryHeaderView(type: item)
            }())
            contentView.frame = frameRect
            return contentView
        }
        if let item = item as? Course {
            let contentView = NSHostingView(rootView: {
                CourseView(course: item)
            }())
            contentView.frame = frameRect
            return contentView
        }

        return nil
    }

    func outlineViewSelectionDidChange(_ notification: Notification) {
        shouldSendSelectionUpdate = false
        let row = outlineView.selectedRow
        if row == -1 {
            selectedCourse?.wrappedValue = nil
        } else {
            let item = outlineView.item(atRow: row)
            if let item = item as? Course {
                selectedCourse?.wrappedValue = .course(item)
            } else if let item = item as? Course.CourseType {
                switch item {
                case .teaching: selectedCourse?.wrappedValue = .allTeaching
                case .enrolled: selectedCourse?.wrappedValue = .allEnrolled
                }
            } else {
                selectedCourse?.wrappedValue = nil
            }
        }
        DispatchQueue.main.async {
            self.shouldSendSelectionUpdate = true
        }
    }

    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        if let item = item as? Course {
            if item.description == nil {
                return 22
            } else {
                return 40
            }
        } else {
            return 22
        }
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
