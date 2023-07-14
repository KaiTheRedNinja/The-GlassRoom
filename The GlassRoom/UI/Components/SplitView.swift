//
//  SplitView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 21/5/23.
//

import SwiftUI

struct SplitView<LView: View, RView: View>: NSViewControllerRepresentable {
    var lView: () -> LView
    var rView: () -> RView

    func makeNSViewController(context: Context) -> NSViewController {
        let controller = SplitViewController()
        controller.vcLeft = NSHostingController(rootView: lView())
        controller.vcRight = NSHostingController(rootView: rView())

        // I'm not sure if this has any impact
        // controller.view.frame = CGRect(origin: .zero, size: CGSize(width: 800, height: 800))
        return controller
    }

    func updateNSViewController(_ nsViewController: NSViewController, context: Context) {
        // nothing here
    }
}

class SplitViewController: NSSplitViewController {
    private let splitViewResorationIdentifier = "org.sstinc.glassroom.restorationId:mainSplitViewController"
    var vcLeft: NSViewController!
    var vcRight: NSViewController!

    override func viewDidLoad() {
        splitView.setValue(NSColor.clear, forKey: "dividerColor")
        splitView.dividerStyle = .thin
        splitView.autosaveName = NSSplitView.AutosaveName(splitViewResorationIdentifier)
        splitView.identifier = NSUserInterfaceItemIdentifier(rawValue: splitViewResorationIdentifier)
        // I've set it to small values like 30 and 70 for the playground
        // For real world, set the minimum width for each pane
        // Else the pane will become fully collapsable
        vcLeft.view.widthAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        vcRight.view.widthAnchor.constraint(greaterThanOrEqualToConstant: 70).isActive = true
        let sidebarItem = NSSplitViewItem(viewController: vcLeft)
        sidebarItem.canCollapse = false
        addSplitViewItem(sidebarItem)
        let mainItem = NSSplitViewItem(viewController: vcRight)
        addSplitViewItem(mainItem)
    }
}

class InvisibleDividerSplitView: NSSplitView {
    override var dividerColor: NSColor { .clear }
}
