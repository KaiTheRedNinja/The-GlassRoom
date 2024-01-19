//
//  SidebarView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 13/5/23.
//

import SwiftUI
import GlassRoomTypes
import GlassRoomInterface
#if os(macOS)
import KeyboardShortcuts
#endif

struct SidebarView: View {
    @Binding var selection: GeneralCourse?
    @ObservedObject var coursesManager: GlobalCoursesDataManager = .global

    @State var renamedGroup: String?
    @State var renamedCourse: String?

    var body: some View {
        SidebarOutlineView(
            selectedCourse: $selection,
            renamedGroup: $renamedGroup,
            renamedCourse: $renamedCourse,
            courses: coursesManager.courses
        )
        .overlay {
            if coursesManager.courses.isEmpty {
                VStack {
                    Text("No Courses")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                if coursesManager.loading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(.init(0.45))
                        .offset(x: -10)
                } else {
                    Button {
                        coursesManager.loadList(bypassCache: true)
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .buttonStyle(.plain)
//                    .onKeyboardShortcut(.reloadSidebar, type: .keyUp) {
//                        coursesManager.loadList(bypassCache: true)
//                    }
                    .keyboardShortcut("r", modifiers: [.command, .shift])
                    .contextMenu {
                        Button("Load Only Cache") {
                            coursesManager.loadList(bypassCache: false)
                        }
                        Button("Reset Cache And Load") {
                            coursesManager.clearCache()
                            coursesManager.loadList(bypassCache: true)
                        }
                    }
                    .offset(y: -1)
                    .help("Refresh Courses (⌘⇧R)")
                }
                Spacer()
            }
            .padding(3)
            .frame(height: 22)
            .background(.primary.opacity(0.2))
            .cornerRadius(8)
            .padding(5)
            .padding(.top, -14)
        }
        .sheet(item: $renamedGroup) { item in
            RenameCourseGroupView(groupString: item)
        }
        .sheet(item: $renamedCourse) { item in
            RenameCourseView(courseString: item)
        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(selection: .constant(nil))
    }
}
