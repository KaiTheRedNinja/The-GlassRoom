//
//  SidebarOutlineViewController.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 13/5/23.
//

import SwiftUI
import GlassRoomTypes

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
    var courseGroups: [CourseGroup] = []

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
            return 2 // teaching and enrolled
        }
        if let item = item as? GeneralCourse {
            switch item {
            case .course(_):
                return 0
            case .allTeaching, .allEnrolled:
                let matchType = item == .allTeaching ? Course.CourseType.teaching : .enrolled
                let matchingCourseGroups = courseGroups.filter({ group in
                    group.groupType == matchType // must match type
                })
                let coursesCount = courses.filter({ course in
                    course.courseType == matchType && // must match type
                    !matchingCourseGroups.contains(where: { $0.courses.contains(course.id) }) // must not be in any other grp
                }).count
                return matchingCourseGroups.count + coursesCount
            case .group(let string):
                if let courseGroup = courseGroups.first(where: { $0.id == string }) {
                    return courseGroup.courses.count
                }
            }
        }

        fatalError("Unexpected item: \(item)")
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        guard let item else {
            if index == 0 {
                return GeneralCourse.allTeaching
            }
            if index == 1 {
                return GeneralCourse.allEnrolled
            }
            fatalError("Unexpected top level value found: \(index)")
        }
        if let item = item as? GeneralCourse {
            switch item {
            case .course(let string):
                return string
            case .allTeaching, .allEnrolled:
                let matchType = item == .allTeaching ? Course.CourseType.teaching : .enrolled
                let matchingCourseGroups = courseGroups.filter({ group in
                    group.groupType == matchType // must match type
                })
                let matchingCourses = courses.filter({ course in
                    course.courseType == matchType && // must match type
                    !matchingCourseGroups.contains(where: { $0.courses.contains(course.id) }) // must not be in any other grp
                })

                if index < courseGroups.count { // use the course groups
                    return GeneralCourse.group(matchingCourseGroups[index].id)
                } else {
                    return GeneralCourse.course(matchingCourses[index-courseGroups.count].id)
                }
            case .group(let string):
                if let courseGroup = courseGroups.first(where: { $0.id == string }) {
                    return GeneralCourse.course(courseGroup.courses[index])
                }
            }
        }

        fatalError("Unexpected item: \(item)")
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let item = item as? GeneralCourse {
            switch item {
            case .course(_):
                return false
            default:
                return true
            }
        }

        fatalError("Non-course item found in outlineview")
    }

    func updateSelection() {
        guard let item = selectedCourse?.wrappedValue else {
            outlineView.deselectRow(outlineView.selectedRow)
            return
        }

        for rowIndex in 0..<outlineView.numberOfRows {
            guard let rowItem = outlineView.item(atRow: rowIndex) as? GeneralCourse else { continue }
            if rowItem.id == item.id {
                outlineView.selectRowIndexes(.init(integer: rowIndex), byExtendingSelection: false)
                return
            }
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
        guard let tableColumn, let item = item as? GeneralCourse else {
            fatalError("Table column or item not found")
        }

        let frameRect = NSRect(x: 0.0,
                               y: 0.0,
                               width: tableColumn.width,
                               height: self.outlineView(outlineView, heightOfRowByItem: item))

        let contentView = NSHostingView(rootView: {
            SidebarCourseView(course: item)
        }())
        contentView.frame = frameRect

        return contentView
    }

    func outlineViewSelectionDidChange(_ notification: Notification) {
        shouldSendSelectionUpdate = false
        defer {
            DispatchQueue.main.async {
                self.shouldSendSelectionUpdate = true
            }
        }

        let row = outlineView.selectedRow
        guard row != -1, let item = outlineView.item(atRow: row) as? GeneralCourse else {
            Log.error("Could not identify item at row \(row)")
            selectedCourse?.wrappedValue = nil
            return
        }

        selectedCourse?.wrappedValue = item
    }

    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        guard let item = item as? GeneralCourse else {
            fatalError("Asked for height of non course item: \(item)")
        }
        switch item {
        case .course(let string):
            if let course = courses.first(where: { $0.id == string }) {
                if course.description != nil {
                    return 40
                }
            }
        default: break
        }

        return 22
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
