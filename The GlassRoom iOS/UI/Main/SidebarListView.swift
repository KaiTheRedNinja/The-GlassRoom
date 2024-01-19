//
//  SidebarListView.swift
//  The GlassRoom iOS
//
//  Created by Kai Quan Tay on 1/7/23.
//

import SwiftUI
import GlassRoomTypes
import GlassRoomAPI
import GlassRoomInterface

struct SidebarListView: View {
    
    @Binding var selection: GeneralCourse?
    @ObservedObject var coursesManager: GlobalCoursesDataManager = .global
    @ObservedObject var configuration: CoursesConfiguration = .global
    
    @State var searchQuery: String = ""

    @State var renamedGeneralCourse: GeneralCourse?

    @State var teachingCollapsed: Bool = false { didSet {
        UserDefaults.standard.set(teachingCollapsed, forKey: "teachingCollapsed")
    }}
    @State var enrolledCollapsed: Bool = false { didSet {
        UserDefaults.standard.set(enrolledCollapsed, forKey: "enrolledCollapsed")
    }}
    @State var archiveCollapsed: Bool = true { didSet {
        UserDefaults.standard.set(archiveCollapsed, forKey: "archiveCollapsed")
    }}

    init(selection: Binding<GeneralCourse?>) {
        self._selection = selection

        let standard = UserDefaults.standard

        teachingCollapsed = standard.bool(forKey: "teachingCollapsed")
        enrolledCollapsed = standard.bool(forKey: "enrolledCollapsed")
        archiveCollapsed = standard.bool(forKey: "archiveCollapsed")
    }

    var body: some View {
        List(selection: $selection) {
            if searchQuery.isEmpty {
                defaultListContent
            } else {
                ForEach(coursesForQuery(query: searchQuery)) { course in
                    sidebarCourseView(course: .course(course.id))
                }
            }
        }
        .navigationTitle(UIScreen.main.traitCollection.userInterfaceIdiom == .pad ? "Glassroom" : "")
        .listStyle(.insetGrouped)
        .searchable(text: $searchQuery)
        .onAppear {
            coursesManager.loadList()
        }
        .alert("Rename", isPresented: .init(
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

    @ViewBuilder
    var defaultListContent: some View {
        if coursesManager.courses.contains(where: { $0.courseType == .teaching }) {
            // Teaching
            Section {
                if !teachingCollapsed {
                    groupsForCourseType(type: .teaching)
                    viewForCourseType(type: .teaching)
                }
            } header: {
                HStack {
                    sidebarCourseView(course: .allTeaching)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 8)
                        .rotationEffect(teachingCollapsed ? .degrees(-90) : .zero)
                        .foregroundColor(.blue)
                }
                .onTapGesture {
                    withAnimation {
                        teachingCollapsed.toggle()
                    }
                }
            }
        }

        if coursesManager.courses.contains(where: { $0.courseType == .enrolled }) {
            // Learning
            Section {
                if !enrolledCollapsed {
                    groupsForCourseType(type: .enrolled)
                    viewForCourseType(type: .enrolled)
                }
            } header: {
                HStack {
                    sidebarCourseView(course: .allEnrolled)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 8)
                        .rotationEffect(enrolledCollapsed ? .degrees(-90) : .zero)
                        .foregroundColor(.blue)
                }
                .onTapGesture {
                    withAnimation {
                        enrolledCollapsed.toggle()
                    }
                }
            }
        }

        if let archive = configuration.archive {
            Section {
                if !archiveCollapsed {
                    ForEach(archive.courses) { courseId in
                        sidebarCourseView(course: .course(courseId))
                    }
                }
            } header: {
                HStack {
                    sidebarCourseView(course: .group(CourseGroup.archiveId))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 8)
                        .rotationEffect(archiveCollapsed ? .degrees(-90) : .zero)
                        .foregroundColor(.blue)
                }
                .onTapGesture {
                    withAnimation {
                        archiveCollapsed.toggle()
                    }
                }
            }
        }
    }

    func coursesForQuery(query: String) -> [Course] {
        let lowerQuery = query.lowercased()
        return coursesManager.courses.filter { course in
            configuration.nameFor(course).lowercased().contains(lowerQuery) &&
            !(configuration.archive?.courses.contains(course.id) ?? false)
        }
    }

    func sidebarCourseView(course: GeneralCourse) -> some View {
        SidebarCourseView(course: course)
            .contextMenu {
                switch course {
                case .course(let id):
                    Section {
                        Button {
                            renamedGeneralCourse = course
                        } label: {
                            Label("Rename Course", systemImage: "pencil")
                        }
                    }

                    Section("Group") {
                        let isArchived = configuration.archive?.courses.contains(id) ?? false
                        let isInGroup = configuration.courseGroups.contains(where: { $0.courses.contains(id) })
                        Button {
                            // create new group
                            guard let course = coursesManager.courses.first(where: { $0.id == id }) else { return }

                            // remove the items from where they came from
                            configuration.archive?.courses.removeAll(where: { $0.id == id })
                            for index in 0..<configuration.courseGroups.count {
                                configuration.courseGroups[index].courses.removeAll(where: { $0.id == id })
                            }

                            // create new group
                            configuration.courseGroups.append(
                                .init(groupName: "Untitled Group",
                                      groupType: course.courseType,
                                      courses: [id])
                            )
                            configuration.saveToFileSystem()
                        } label: {
                            Label("\(isArchived ? "Unarchive and " : "")\(isInGroup ? "Move to" : "Create") new Group", systemImage: "folder.badge.plus")
                        }
                        Menu {
                            ForEach(configuration.courseGroups) { group in
                                Button(group.groupName) { // add to that group
                                    // remove the items from where they came from
                                    configuration.archive?.courses.removeAll(where: { $0.id == id })
                                    for index in 0..<configuration.courseGroups.count {
                                        configuration.courseGroups[index].courses.removeAll(where: { $0.id == id })
                                    }

                                    guard let destIndex = configuration.courseGroups.firstIndex(of: group) else { return }
                                    configuration.courseGroups[destIndex].courses.append(id)
                                    configuration.saveToFileSystem()
                                }
                            }
                        } label: {
                            Label("\(isArchived ? "Unarchive and " : "")\(isInGroup ? "Move" : "Add") to Group", systemImage: isInGroup ? "arrow.up.and.down.and.arrow.left.and.right" : "plus.circle")
                        }
                        if isInGroup {
                            Button(role: .destructive) { // remove from grp
                                configuration.archive?.courses.removeAll(where: { $0.id == id })
                                for index in 0..<configuration.courseGroups.count {
                                    configuration.courseGroups[index].courses.removeAll(where: { $0.id == id })
                                }
                                configuration.saveToFileSystem()
                            } label: {
                                Label("Remove from Group", systemImage: "folder.badge.minus")
                            }
                        }
                    }
                    
                    Section("Archive") {
                        let isArchived = configuration.archive?.courses.contains(id) ?? false
                        Button(role: isArchived ? .none : .destructive) {
                            configuration.archive(item: course)
                            configuration.saveToFileSystem()
                        } label: {
                            Label("\(isArchived ? "Unarchive" : "Archive") Course", systemImage: "archivebox")
                        }
                    }
                case .group(let id):
                    if id != CourseGroup.archiveId {
                        Button {
                            renamedGeneralCourse = course
                        } label: {
                            Label("Rename Group", systemImage: "pencil")
                        }
                        
                        Button {
                            // add contents of group to that group
                            configuration.archive(item: course)
                            configuration.saveToFileSystem()
                        } label: {
                            Label("Archive Courses in Group", systemImage: "archivebox")
                        }

                        if configuration.courseGroups.count > 1 {
                            Menu {
                                ForEach(configuration.courseGroups) { group in
                                    if group.id != id {
                                        Button(group.groupName) {
                                            // add contents of group to that group
                                            guard let sourceIndex = configuration.courseGroups.firstIndex(where: { $0.id == id }),
                                                  let destIndex = configuration.courseGroups.firstIndex(of: group)
                                            else { return }
                                            configuration.courseGroups[destIndex].courses.append(
                                                contentsOf: configuration.courseGroups[sourceIndex].courses
                                            )
                                            configuration.courseGroups.removeAll(where: { $0.id == id })
                                            configuration.saveToFileSystem()
                                        }
                                    }
                                }
                            } label: {
                                Label("Merge with Group", systemImage: "arrow.triangle.merge")
                            }
                        }

                        Divider()
                        
                        Button(role: .destructive) {
                            configuration.courseGroups.removeAll(where: { $0.id == id })
                            configuration.saveToFileSystem()
                        } label: {
                            Label("Delete Group", systemImage: "trash")
                        }
                    }
                default:
                    EmptyView()
                }
            }
            .tag(course)
    }

    func viewForCourseType(type: Course.CourseType) -> some View {
        ForEach(coursesManager.courses) { course in
            if course.courseType == type, // correct type
               !(configuration.archive?.courses.contains(course.id) ?? false), // not archived
               !configuration.courseGroups.contains(where: { $0.courses.contains(course.id) }) { // not grouped
                sidebarCourseView(course: .course(course.id))
            }
        }
    }

    func groupsForCourseType(type: Course.CourseType) -> some View {
        ForEach(configuration.courseGroups.filter({ $0.groupType == type})) { group in
            DisclosureGroup {
                ForEach(group.courses) { courseId in
                    sidebarCourseView(course: .course(courseId))
                }
            } label: {
                sidebarCourseView(course: .group(group.id))
            }
        }
    }
}
