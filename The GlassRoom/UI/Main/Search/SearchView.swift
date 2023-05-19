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
    
    @FocusState var textfieldFocused: Bool

    @ObservedObject var courseManager: GlobalCoursesDataManager = .global
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 0) {
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
            
            Divider()
                .padding(.top, 10)
            
            HStack(spacing: 0) {
                List(selection: $selection) {
                    ForEach(matchingCourses(), id: \.id) { course in
                        Text(courseManager.configuration.nameFor(course.name))
                            .tag("course_" + course.id)
                            .onTapGesture {
                                if "course_\(course.id)" == selection {
                                    open()
                                } else {
                                    selection = "course_" + course.id
                                }
                            }
                    }
                }
                if let selection {
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
        }
        .frame(width: 680,
               height: 500)
        .onAppear {
            textfieldFocused = true
        }
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

    func matchingCourses() -> [Course] {
        let courses = courseManager.courses
        if searchTerm.isEmpty { return courses }
        let archived = courseManager.configuration.archive?.courses ?? []

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
