//
//  SidebarView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 13/5/23.
//

import SwiftUI
import GlassRoomTypes
import GlassRoomInterface

struct SidebarView: View {
    @Binding var selection: GeneralCourse?
    @ObservedObject var coursesManager: GlobalCoursesDataManager = .global

    @State var renamedGeneralCourse: GeneralCourse?

    var body: some View {
        SidebarOutlineView(
            selectedCourse: $selection,
            renamedGeneralCourse: $renamedGeneralCourse,
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
        .alert("Rename \(renamedGeneralCourse?.caseName ?? "")", isPresented: .init(
            get: { renamedGeneralCourse != nil },
            set: { renamedGeneralCourse = $0 ? renamedGeneralCourse : nil })
        ) {
            if let renamedGeneralCourse {
                RenameCourseView(generalCourse: renamedGeneralCourse)
            } else {
                Text("Error")
            }
        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(selection: .constant(nil))
    }
}
