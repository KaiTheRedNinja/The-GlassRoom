//
//  CustomisationView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 16/5/23.
//

import SwiftUI

struct CustomisationView: View {
    @ObservedObject var coursesManager: GlobalCoursesDataManager = .global

    @State var selectedNameReplacement: UUID?
    @State var showEditPopup: Bool = false

    @State var replacedCourseNames: [NameReplacement] = []

    var body: some View {
        VStack {
            HStack {
                List() {
                    ForEach(coursesManager.courses, id: \.id) { course in
                        ColorPicker(
                            course.name,
                            selection: .init(get: {
                                coursesManager.configuration.colorFor(course.id)
                            }, set: { newColor in
                                coursesManager.configuration.customColors[course.id] = newColor
                            })
                        )
                        .tag(course)
                    }
                }

                // TODO: Reload this when replaced course names changes
                Table(replacedCourseNames, selection: $selectedNameReplacement) {
                    TableColumn("Match Regex") { nameReplacement in
                        Text(nameReplacement.matchString)
                    }
                    TableColumn("Replacement") { nameReplacement in
                        Text(nameReplacement.replacement)
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    HStack {
                        Button {
                            guard let selectedNameReplacement else { return }
                            coursesManager.configuration.replacedCourseNames.removeAll {
                                $0.id == selectedNameReplacement
                            }
                            replacedCourseNames = coursesManager.configuration.replacedCourseNames
                        } label: {
                            Image(systemName: "minus")
                        }
                        Button {
                            let newItem: NameReplacement
                            if let existingItem = coursesManager.configuration.replacedCourseNames
                                .first(where: { $0.matchString == "Match String" }) {
                                newItem = existingItem
                            } else {
                                newItem = .init(
                                    matchString: "Match String",
                                    replacement: "Replacement"
                                )
                            }
                            coursesManager.configuration.replacedCourseNames.append(newItem)
                            selectedNameReplacement = newItem.id
                            showEditPopup.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                        Button {
                            showEditPopup.toggle()
                        } label: {
                            Image(systemName: "pencil")
                        }
                        Spacer()
                    }
                    .buttonStyle(.plain)
                    .padding(.vertical, 3)
                }
                .onAppear {
                    replacedCourseNames = coursesManager.configuration.replacedCourseNames
                }
                .onChange(of: coursesManager.configuration.replacedCourseNames) { _ in
                    replacedCourseNames = coursesManager.configuration.replacedCourseNames
                }
            }
            HStack {
                Spacer()
                Button("Save") {
                    coursesManager.configuration.saveToFileSystem()
                    coursesManager.configuration.objectWillChange.send()
                }
            }
        }
        .padding(15)
        .sheet(isPresented: $showEditPopup) {
            if let selectedNameReplacement,
               let nameReplacementIndex = coursesManager.configuration.replacedCourseNames.firstIndex(where: { $0.id == selectedNameReplacement }) {
                let nameReplacement = coursesManager.configuration.replacedCourseNames[nameReplacementIndex]
                EditNameReplacementView(nameReplacement: nameReplacement) { newMatchString, newReplacement in
                    coursesManager.configuration.replacedCourseNames[nameReplacementIndex].matchString = newMatchString
                    coursesManager.configuration.replacedCourseNames[nameReplacementIndex].replacement = newReplacement

                    replacedCourseNames = coursesManager.configuration.replacedCourseNames
                }
                .padding(15)
            }
        }
    }

    struct EditNameReplacementView: View {
        @State var matchString: String
        @State var replacement: String

        var submitChange: (String, String) -> Void

        @Environment(\.presentationMode) var presentationMode

        init(nameReplacement: NameReplacement, submitChange: @escaping (String, String) -> Void) {
            self._matchString = State(initialValue: nameReplacement.matchString)
            self._replacement = State(initialValue: nameReplacement.replacement)

            self.submitChange = submitChange
        }

        var body: some View {
            Form {
                TextField("Match Regex", text: $matchString)
                TextField("Match Text", text: $replacement)
                Button("Save") {
                    submitChange(matchString, replacement)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct CustomisationView_Previews: PreviewProvider {
    static var previews: some View {
        CustomisationView()
    }
}
