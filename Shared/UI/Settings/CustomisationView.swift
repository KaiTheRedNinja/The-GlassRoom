//
//  CustomisationView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 16/5/23.
//

import SwiftUI

struct CustomisationView: View {
    @ObservedObject var coursesManager: GlobalCoursesDataManager = .global
    @ObservedObject var configuration = GlobalCoursesDataManager.global.configuration

    @State var selectedIconReplacement: String?
    @State var showIconPopup: Bool = false

    @State var selectedNameReplacement: UUID?
    @State var showEditPopup: Bool = false

    @State var replacedCourseNames: [NameReplacement] = []

    var body: some View {
        VStack {
            #if os(macOS)
            HStack {
                coloursList
                regexTable
            }
            #else
            Form {
                DisclosureGroup("Colours") {
                    coloursList
                }
                
                DisclosureGroup("Regex") {
                    regexTable
                }
            }
            #endif
            
            HStack {
                Spacer()
                Button("Save") {
                    configuration.saveToFileSystem()
                    configuration.objectWillChange.send()
                }
            }
            .padding(.horizontal)
        }
        #if os(macOS)
        .padding(15)
        #endif
        .sheet(isPresented: $showEditPopup) {
            if let selectedNameReplacement,
               let nameReplacementIndex = configuration.replacedCourseNames.firstIndex(where: { $0.id == selectedNameReplacement }) {
                let nameReplacement = configuration.replacedCourseNames[nameReplacementIndex]
                EditNameReplacementView(nameReplacement: nameReplacement) { newMatchString, newReplacement in
                    configuration.replacedCourseNames[nameReplacementIndex].matchString = newMatchString
                    configuration.replacedCourseNames[nameReplacementIndex].replacement = newReplacement

                    replacedCourseNames = configuration.replacedCourseNames
                }
                .padding(15)
            }
        }
    }
    
    var coloursList: some View {
        List {
            ForEach(coursesManager.courses, id: \.id) { course in
                HStack {
                    Text(course.name)
                    Spacer()
                    Circle()
                        .fill(configuration.colorFor(course.id))
                        .reverseMask {
                            Image(systemName: configuration.iconFor(course.id))
                                .resizable()
                                .scaledToFit()
                                .padding(3)
                        }
                        .frame(width: 20, height: 18)
                        .foregroundColor(.accentColor)
                        .disabled(true)
                }
                .tag(course)
                .onTapGesture {
                    selectedIconReplacement = course.id
                    showIconPopup = true
                }
            }
        }
        .background {
            #if os(macOS)
            SymbolPickerView(
                showSymbolPicker: $showIconPopup,
                selectedSymbol: .init(get: {
                    if let selectedIconReplacement {
                        return configuration.iconFor(selectedIconReplacement)
                    } else {
                        return "person.2.fill"
                    }
                }, set: { newValue in
                    configuration.customIcons[selectedIconReplacement!] = newValue
                }),
                selectedColor: .init(get: {
                    if let selectedIconReplacement {
                        return configuration.colorFor(selectedIconReplacement)
                    } else {
                        return .accentColor
                    }
                }, set: { newValue in
                    configuration.customColors[selectedIconReplacement!] = newValue
                }),
                title: "Choose Icon and Color"
            )
            #endif
        }
    }
    
    var regexTable: some View {
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
                    configuration.replacedCourseNames.removeAll {
                        $0.id == selectedNameReplacement
                    }
                    replacedCourseNames = configuration.replacedCourseNames
                } label: {
                    Image(systemName: "minus")
                }
                Button {
                    let newItem: NameReplacement
                    if let existingItem = configuration.replacedCourseNames
                        .first(where: { $0.matchString == "Match String" }) {
                        newItem = existingItem
                    } else {
                        newItem = .init(
                            matchString: "Match String",
                            replacement: "Replacement"
                        )
                    }
                    configuration.replacedCourseNames.append(newItem)
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
            replacedCourseNames = configuration.replacedCourseNames
        }
        .onChange(of: configuration.replacedCourseNames) { _ in
            replacedCourseNames = configuration.replacedCourseNames
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
