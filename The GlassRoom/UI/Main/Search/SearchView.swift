//
//  SearchView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 14/5/23.
//

import SwiftUI
import GlassRoomTypes

struct SearchView: View {
    @SceneStorage("searchTerm") var searchTerm: String = ""

    @Binding var selectedCourse: GeneralCourse?
    @Binding var selectedPost: CoursePost?

    @State var selection: String?
    @State var showPostsPreview: Bool = false

    @FocusState var textfieldFocused: Bool

    @ObservedObject var courseManager: GlobalCoursesDataManager = .global
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 0) {
            searchField
            
            Divider()
                .padding(.top, 10)
            
            HStack(spacing: 0) {
                searchResults
                postsPreview
            }
        }
        .frame(width: showPostsPreview ? 680 : 500,
               height: showPostsPreview ? 500 : 400)
        .onAppear {
            textfieldFocused = true
        }
    }

    var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.gray)
                .background {
                    ZStack {
                        Button("U") { // up
                            changeSelection(by: -1)
                        }
                        .keyboardShortcut(KeyEquivalent.upArrow, modifiers: [])
                        Button("D") { // down
                            changeSelection(by: 1)
                        }
                        .keyboardShortcut(KeyEquivalent.downArrow, modifiers: [])
                        Button("E") { // enter
                            open()
                        }
                        .keyboardShortcut(KeyEquivalent.return, modifiers: [])
                        Button("R") { // to the right
                            showPostsPreview.toggle()
                        }
                        .keyboardShortcut(KeyEquivalent.rightArrow, modifiers: [])
                    }
                    .opacity(0)
                }

            TextField("Search Classes or Posts", text: $searchTerm)
                .focused($textfieldFocused)
                .textFieldStyle(.plain)
                .font(.system(.title2))
                .frame(maxHeight: .infinity)
                .onSubmit {
                    open()
                }
        }
        .offset(y: 4)
        .frame(height: 30)
        .padding(.horizontal, 15)
        .padding(.top, 5)
    }

    var searchResults: some View {
        List(selection: $selection) {
            let courses = matchingCourses()
            let postParents = matchingPostsParentCourses()
            if !courses.isEmpty {
                Section("Courses") {
                    ForEach(courses, id: \.id) { course in
                        HStack {
                            Text(courseManager.configuration.nameFor(course.name))
                                .onTapGesture {
                                    if "course_\(course.id)" == selection {
                                        open()
                                    } else {
                                        selection = "course_" + course.id
                                    }
                                }
                            if selection == "course_" + course.id && !showPostsPreview {
                                Spacer()
                                Text("Press -> for preview")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .tag("course_" + course.id)
                    }
                }
            }

            if !postParents.isEmpty {
                Section("Posts") {
                    ForEach(postParents, id: \.0.id) { (course, posts) in
                        HStack {
                            Text(courseManager.configuration.nameFor(course.name))
                                .onTapGesture {
                                    if "course_\(course.id)" == selection {
                                        open()
                                    } else {
                                        selection = "course_" + course.id
                                    }
                                }
                            Text("\(posts.count) Matches")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("Press -> for preview")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .onChange(of: selection) { _ in
            if selection == nil {
                showPostsPreview = false
            }
        }
    }

    @ViewBuilder
    var postsPreview: some View {
        if let selection, showPostsPreview {
            Divider()
            SingleCoursePostListView(
                selectedPost: .init(get: { nil }, set: { newPost in
                    // TODO: Open the post
                    guard let newPost else { return }
                    open(post: newPost)
                }),
                displayOption: .constant(.allPosts),
                posts: .getManager(for: selection.replacingOccurrences(of: "course_", with: ""))
            )
            .id(selection)
        }
    }

    func matchingCourses() -> [Course] {
        let courses = courseManager.courses
        let archived = courseManager.configuration.archive?.courses ?? []

        guard !searchTerm.isEmpty else {
            return courses.filter({ !archived.contains($0.id) })
        }

        let filteredCourses = courses.filter { course in
            let fixedName = courseManager.configuration.nameFor(course.name).lowercased()
            let nameContains = fixedName.contains(searchTerm) || course.name.lowercased().contains(searchTerm)
            //            let descriptionContains = (course.description?.lowercased().contains(searchTerm) ?? false)
            return nameContains && !archived.contains(course.id)
        }
        // if the filtered courses do not contain the selected course, select the first one.
        if let selection {
            if !filteredCourses.contains(where: { "course_" + $0.id == selection }),
               let firstCourse = filteredCourses.first?.id {
                DispatchQueue.main.async {
                    self.selection = "course_" + firstCourse
                }
            }
        } else if let firstCourse = filteredCourses.first?.id {
            DispatchQueue.main.async {
                selection = "course_" + firstCourse
            }
        }
        return filteredCourses
    }

    func matchingPostsParentCourses() -> [(Course, [CoursePost])] {
        guard searchTerm.count > 3 else { return [] } // make sure that we don't have too many results

        // go through the loaded post managers and search
        var result: [(Course, [CoursePost])] = []
        for (courseId, postsManager) in CoursePostsDataManager.loadedManagers {
            let matchingPosts = postsManager.postData.filter { post in
                switch post {
                case .announcement(let courseAnnouncement):
                    return courseAnnouncement.text.lowercased().contains(searchTerm.lowercased())
                case .courseWork(let courseWork):
                    return courseWork.title.lowercased().contains(searchTerm.lowercased()) ||
                    (courseWork.description?.lowercased().contains(searchTerm.lowercased()) ?? false)
                case .courseMaterial(let courseWorkMaterial):
                    return courseWorkMaterial.title.lowercased().contains(searchTerm.lowercased()) ||
                    (courseWorkMaterial.description?.lowercased().contains(searchTerm.lowercased()) ?? false)
                }
            }
            if !matchingPosts.isEmpty, let course = courseManager.courseIdMap[courseId] {
                result.append((course, matchingPosts))
            }
        }

        // TODO: Sort results

        return result
    }

    func open(post: CoursePost? = nil) {
        defer { presentationMode.wrappedValue.dismiss() }
        guard let selection else { return }
        selectedCourse = .course(selection.replacingOccurrences(of: "course_", with: ""))
        selectedPost = post
    }

    func changeSelection(by offset: Int) {
        let courses = matchingCourses()
        guard let selection,
              let selectedIndex = courses.firstIndex(where: { "course_" + $0.id == selection })
        else {
            if let firstCourse = courses.first?.id {
                DispatchQueue.main.async {
                    self.selection = "course_" + firstCourse
                }
            }
            return
        }
        let newCourse = courses[(selectedIndex+offset)%%courses.count]
        DispatchQueue.main.async {
            self.selection = "course_" + newCourse.id
        }
    }
}

infix operator %%
extension Int {
    static func %% (_ left: Int, _ right: Int) -> Int {
        if left >= 0 { return left % right }
        if left >= -right { return (left+right) }
        return ((left % right)+right)%right
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(selectedCourse: .constant(nil), selectedPost: .constant(nil))
    }
}
