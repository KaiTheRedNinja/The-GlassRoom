//
//  SearchView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 14/5/23.
//

import SwiftUI
import GlassRoomAPI

struct SearchView: View {
    @SceneStorage("searchTerm") var searchTerm: String = ""

    @Binding var selectedCourse: Course?
    @Binding var selectedPost: CourseAnnouncement?

    @State var selection: String?

    @ObservedObject var courseManager: GlobalCoursesDataManager = .global
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.gray)
                    .background {
                        ZStack {
                            Button("U") {
                                changeSelection(by: -1)
                            }
                            .keyboardShortcut(KeyEquivalent.upArrow, modifiers: [])
                            Button("D") {
                                changeSelection(by: 1)
                            }
                            .keyboardShortcut(KeyEquivalent.downArrow, modifiers: [])
                        }
                        .opacity(0)
                    }
                TextField("Search Classes or Announcements", text: $searchTerm)
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
            List(selection: $selection) {
                ForEach(matchingCourses(), id: \.id) { course in
                    Text(course.name)
                        .tag("course_" + course.id)
                        .onTapGesture {
                            selection = "course_" + course.id
                        }
                        .onTapGesture(count: 2) {
                            open()
                        }
                }
            }
        }
        .frame(width: 450, height: 400)
    }

    func open() {
        defer { presentationMode.wrappedValue.dismiss() }
        guard let selection else { return }
        selectedCourse = courseManager.courses.first(where: { "course_" + $0.id == selection })
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

        let filteredCourses = courses.filter { course in
            course.name.lowercased().contains(searchTerm) || (course.description?.lowercased().contains(searchTerm) ?? false)
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
