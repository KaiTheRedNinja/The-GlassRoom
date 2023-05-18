//
//  SidebarOutlineView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 13/5/23.
//

import SwiftUI
import GlassRoomTypes

/// Wraps an ``SidebarOutlineViewController`` inside a `NSViewControllerRepresentable`
struct SidebarOutlineView: NSViewControllerRepresentable {
    typealias NSViewControllerType = SidebarOutlineViewController

    @Binding var selectedCourse: GeneralCourse?
    var courses: [Course]

    @ObservedObject var configuration = GlobalCoursesDataManager.global.configuration

    func makeNSViewController(context: Context) -> SidebarOutlineViewController {
        let controller = SidebarOutlineViewController()
        controller.courses = self.courses
        controller.selectedCourse = $selectedCourse
        controller.updateGroups = { groups in
            configuration.courseGroups = groups
            configuration.saveToFileSystem()
        }
        return controller
    }

    func updateNSViewController(_ nsViewController: SidebarOutlineViewController, context: Context) {
        nsViewController.courses = self.courses
        nsViewController.courseGroups = configuration.courseGroups
        nsViewController.selectedCourse = $selectedCourse
        nsViewController.outlineView.reloadData()
        nsViewController.updateSelection()
        return
    }
}
