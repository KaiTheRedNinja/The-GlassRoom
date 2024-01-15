//
//  SearchView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 14/5/23.
//

import SwiftUI
import GlassRoomTypes
import GlassRoomInterface

let loadQueue = DispatchQueue(label: "loadQueue")
struct SearchView: View {
    @SceneStorage("searchTerm") var searchTerm: String = ""

    @Binding var selectedCourse: GeneralCourse?
    @Binding var selectedPost: CoursePost?

    @State var selection: Selection?
    @State var showPostsPreview: Bool = false

    @FocusState var textfieldFocused: Bool

    @ObservedObject var courseManager: GlobalCoursesDataManager = .global
    @ObservedObject var configuration: CoursesConfiguration = .global
    @Environment(\.presentationMode) var presentationMode

    @State var resultCourses: [Course] = []
    @State var resultPosts: [(Course, [CoursePost])] = []

    enum Selection: Hashable {
        case course(String)
        case postsParent(String)

        var value: String {
            switch self {
            case .course(let string): return string
            case .postsParent(let string): return string
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            searchField
            
            Divider()
                .padding(.top, 10)
            
            HStack(spacing: 0) {
                searchResults
                postsPreview
            }
            #if os(iOS)
            .animation(.spring(duration: 0.4), value: showPostsPreview)
            #endif
        }
        #if os(macOS)
        .frame(width: showPostsPreview ? 680 : 500,
               height: showPostsPreview ? 500 : 400)
        #else
        .frame(width: 680, height: 500)
        #endif
        #if os(iOS)
        .background(Color(.systemBackground))
        .mask(RoundedRectangle(cornerRadius: 16))
        #endif
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
                #if os(macOS)
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
                #endif

            TextField("Search Classes or Posts", text: $searchTerm)
                .focused($textfieldFocused)
                .textFieldStyle(.plain)
                .font(.system(.title2))
                .frame(maxHeight: .infinity)
                .onSubmit {
                    open()
                }
            
            #if os(iOS)
            Button {
                showPostsPreview.toggle()
            } label: {
                Image(systemName: "sidebar.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.gray)
            }
            .keyboardShortcut(KeyEquivalent.rightArrow, modifiers: [.command, .control])
            #endif
        }
        .offset(y: 4)
        .frame(height: 30)
        .padding(.horizontal, 15)
        .padding(.top, 5)
        #if os(iOS)
        .padding(.vertical, 5)
        .background(Color(.systemBackground))
        #endif
    }

    var searchResults: some View {
        List(selection: $selection) {
            if !resultCourses.isEmpty {
                Section("Courses") {
                    ForEach(resultCourses, id: \.id) { course in
                        HStack {
                            Text(configuration.nameFor(course.name))
                                .onTapGesture {
                                    if selection == .course(course.id) {
                                        open()
                                    } else {
                                        selection = .course(course.id)
                                    }
                                }
                            if selection == .course(course.id) && !showPostsPreview {
                                Spacer()
                                #if os(macOS)
                                Text("Press → for preview")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                #else
                                Text(LocalizedStringKey("Press ⌘⌃→ or \(Image(systemName: "sidebar.right")) for preview"))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                #endif
                            }
                        }
                        .tag(Selection.course(course.id))
                    }
                }
            }

            if !resultPosts.isEmpty {
                Section("Posts") {
                    ForEach(resultPosts, id: \.0.id) { (course, posts) in
                        HStack {
                            Text(configuration.nameFor(course.name))
                                .onTapGesture {
                                    if selection == .postsParent(course.id) {
                                        open()
                                    } else {
                                        selection = .postsParent(course.id)
                                    }
                                }
                            Text("\(posts.count) Matches")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .tag(Selection.postsParent(course.id))
                    }
                }
            }
        }
        .onChange(of: selection) { _ in
            if let selection {
                switch selection {
                case .course(_): break
                case .postsParent(_): showPostsPreview = true
                }
            } else {
                showPostsPreview = false
            }
        }
        .onChange(of: searchTerm) { _ in
            loadQueue.async {
                resultCourses = matchingCourses()
                resultPosts = matchingPostsParentCourses()
            }
        }
        .onAppear {
            loadQueue.async {
                resultCourses = matchingCourses()
                resultPosts = matchingPostsParentCourses()
            }
        }
    }

    @ViewBuilder
    var postsPreview: some View {
        if let selection, showPostsPreview {
            Divider()
            switch selection {
            case .course(_):
                NavigationStack {
                    SingleCoursePostListView(
                        selectedPost: .init(get: { nil }, set: { newPost in
                            // TODO: Open the post
                            guard let newPost else { return }
                            open(post: newPost)
                        }),
                        displayOption: .constant(.allPosts),
                        posts: .getManager(for: selection.value),
                        isInSearch: true
                    )
                    .id(selection)
                #if os(iOS)
                    .listStyle(.plain)
                #endif
                }
            case .postsParent(let courseId):
                List(selection: Binding<CoursePost?>(get: { nil }, set: { newPost in
                    // TODO: Open the post
                    guard let newPost else { return }
                    open(post: newPost)
                })) {
                    CoursePostListView(postData: resultPosts.first(where: { $0.0.id == courseId })?.1 ?? [])
                }
                #if os(iOS)
                .listStyle(.plain)
                #endif
            }
        }
    }

    func matchingCourses() -> [Course] {
        let courses = courseManager.courses
        let archived = configuration.archive?.courses ?? []

        guard !searchTerm.isEmpty else {
            return courses.filter({ !archived.contains($0.id) })
        }

        let filteredCourses = courses.filter { course in
            let fixedName = configuration.nameFor(course.name).lowercased()
            let nameContains = fixedName.contains(searchTerm.lowercased()) || course.name.lowercased().contains(searchTerm.lowercased())
            //            let descriptionContains = (course.description?.lowercased().contains(searchTerm) ?? false)
            return nameContains && !archived.contains(course.id)
        }
        // if the filtered courses do not contain the selected course, select the first one.
        if let selection {
            if !filteredCourses.contains(where: { selection == .course($0.id) }),
               let firstCourse = filteredCourses.first?.id {
                DispatchQueue.main.async {
                    self.selection = .course(firstCourse)
                }
            }
        } else if let firstCourse = filteredCourses.first?.id {
            DispatchQueue.main.async {
                selection = .course(firstCourse)
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
        selectedCourse = .course(selection.value)
        selectedPost = post
    }

    func changeSelection(by offset: Int) {
        // figure out what the current selection is

        let selectedCourseIndex = resultCourses.firstIndex(where: { selection?.value == $0.id })
        let selectedPostParentIndex = resultPosts.firstIndex(where: { selection?.value == $0.0.id })
        var selectionIndex = -1

        if let selection {
            switch selection {
            case .course(_):
                if let selectedCourseIndex {
                    selectionIndex = selectedCourseIndex
                }
            case .postsParent(_):
                if let selectedPostParentIndex {
                    selectionIndex = resultCourses.count + selectedPostParentIndex
                }
            }
        }
        // else, not selected. Leave selection index at -1.

        // figure out what the next one is and select it
        let newIndex = (selectionIndex + offset)%%(resultCourses.count + resultPosts.count)
        if newIndex < resultCourses.count { // new index is a course
            let newCourse = resultCourses[newIndex]
            DispatchQueue.main.async {
                self.selection = .course(newCourse.id)
            }
        } else { // new index is a post parent
            let newPostParent = resultPosts[newIndex-resultCourses.count]
            DispatchQueue.main.async {
                self.selection = .postsParent(newPostParent.0.id)
            }
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
