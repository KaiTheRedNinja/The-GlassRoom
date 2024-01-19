//
//  SidebarOutlineView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 13/5/23.
//

import SwiftUI
import GlassRoomTypes
import GlassRoomInterface

/// Wraps an ``SidebarOutlineViewController`` inside a `NSViewControllerRepresentable`
struct SidebarOutlineView: NSViewControllerRepresentable {
    typealias NSViewControllerType = SidebarOutlineViewController

    @Binding var selectedCourse: GeneralCourse?
    @Binding var renamedGeneralCourse: GeneralCourse?
    var courses: [Course]

    @ObservedObject var configuration = CoursesConfiguration.global

    func makeNSViewController(context: Context) -> SidebarOutlineViewController {
        let controller = SidebarOutlineViewController()
        controller.courses = self.courses
        controller.selectedCourse = $selectedCourse
        controller.renamedGeneralCourse = $renamedGeneralCourse
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
        nsViewController.renamedGeneralCourse = $renamedGeneralCourse
        nsViewController.archive = $configuration.archive
        nsViewController.outlineView.reloadData()
        nsViewController.updateSelection()
        return
    }
}
