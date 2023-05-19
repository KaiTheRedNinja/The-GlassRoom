//
//  CenterSplitViewToolbarTop.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 14/5/23.
//

import SwiftUI
import GlassRoomTypes

struct CenterSplitViewToolbarTop: View {
    typealias CourseDisplayOption = CenterSplitView.CourseDisplayOption
    @Binding var selectedCourse: GeneralCourse?
    @Binding var currentPage: CourseDisplayOption
    @ObservedObject var displayedCourseManager: DisplayedCourseManager

    @State var showSelectionPopup: Bool = false

    @ObservedObject var courseManager: GlobalCoursesDataManager = .global

    var body: some View {
        HStack(alignment: .center) {
            SegmentedControl(.init(get: {
                switch currentPage {
                case .allPosts: return 0
                case .announcements: return 1
                case .courseWork: return 2
                case .courseMaterial: return 3
                case .userRegister: return 4
                }
            }, set: { newValue in
                currentPage = .allCases[newValue]
            }), options: CourseDisplayOption.allCases.map({ $0.rawValue }))
            .animation(.spring(), value: currentPage)

            if let selectedCourse, selectedCourse == .allEnrolled || selectedCourse == .allTeaching {
                filterView
            }
        }
        .animation(.default, value: selectedCourse)
        .padding(.horizontal, 5)
        .frame(height: 25)
        .frame(maxWidth: .infinity)
        .background(.thinMaterial)
        .overlay(alignment: .bottom) {
            Divider()
                .offset(y: 1)
        }
        .padding(.bottom, -7)
    }

    var filterView: some View {
        ZStack {
            let courseType = selectedCourse == .allTeaching ? Course.CourseType.teaching : .enrolled
            Button {
                showSelectionPopup.toggle()
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .overlay(alignment: .bottomTrailing) {
                        let count = displayedCourseManager.displayedAggregateCourseIds.count
                        if count > 0 {
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                Image(systemName: count <= 50 ? "\(count).circle" : "plus.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(1)
                            }
                            .frame(width: 10, height: 10)
                            .offset(x: 1, y: 1)
                        }
                    }
            }
            .popover(isPresented: $showSelectionPopup) {
                List {
                    ForEach(courseManager.courses.filter({ $0.courseType == courseType }), id: \.id) { course in
                        Button {
                            var displayedCourseIds = displayedCourseManager.displayedAggregateCourseIds
                            if let courseIndex = displayedCourseIds.firstIndex(of: course.id) {
                                displayedCourseIds.remove(at: courseIndex)
                            } else {
                                displayedCourseIds.append(course.id)
                            }
                            displayedCourseManager.displayedAggregateCourseIds = displayedCourseIds
                            displayedCourseManager.objectWillChange.send()
                        } label: {
                            HStack {
                                Image(
                                    systemName: displayedCourseManager.displayedAggregateCourseIds.contains(course.id) ?
                                    "checkmark.circle.fill" : "circle"
                                )
                                Text(course.name)
                            }
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(.primary)
                    }
                }
            }
            .buttonStyle(.plain)
            .foregroundColor(.accentColor)
        }
    }
}
