//
//  CustomisationView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 16/5/23.
//

import SwiftUI
import SymbolPicker
import GlassRoomInterface

struct CustomisationView: View {
    @ObservedObject var coursesManager: GlobalCoursesDataManager = .global
    @ObservedObject var configuration: CoursesConfiguration = .global

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
                NavigationLink("Colours and symbols") {
                    coloursList
                }
                
                NavigationLink("Regex renaming") {
                    regexTable
                }
            }
            #endif
            
            #if os(macOS)
            HStack {
                Spacer()
                Button("Save") {
                    configuration.saveToFileSystem()
                    configuration.objectWillChange.send()
                }
                Button("Export") {
                    let path = FileSystem.path(file: .courseConfigurations)
                    NSWorkspace.shared.selectFile(
                        nil,
                        inFileViewerRootedAtPath: path.deletingLastPathComponent().relativePath
                    )
                }
                Button("Share Link") {
                    print(configuration.exportURL())
                }
            }
            .padding(.horizontal)
            #endif
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
                #if os(macOS)
                .padding(15)
                #endif
                #if os(iOS)
                .presentationDetents([.medium])
                #endif
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
                        .frame(width: 24, height: 24)
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
        #if os(iOS)
        .navigationTitle("Colours and symbols")
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .sheet(isPresented: $showIconPopup) {
            NavigationStack {
                SymbolPicker(symbol: .init(get: {
                    if let selectedIconReplacement {
                        return configuration.iconFor(selectedIconReplacement)
                    } else {
                        return "person.2.fill"
                    }
                }, set: { newValue in
                    configuration.customIcons[selectedIconReplacement!] = newValue
                }))
                #if os(macOS)
                .safeAreaInset(edge: .bottom) {
                    Rectangle().fill(.thinMaterial)
                        .overlay {
                            HStack {
                                Spacer()
                                ColorPicker("Color", selection: .init(get: {
                                    if let selectedIconReplacement {
                                        return configuration.colorFor(selectedIconReplacement)
                                    } else {
                                        return .accentColor
                                    }
                                }, set: { newValue in
                                    configuration.customColors[selectedIconReplacement!] = newValue
                                }))
                            }
                            .padding(.horizontal, 10)
                        }
                        .frame(height: 30)
                        .overlay(alignment: .top) {
                            Divider()
                        }
                }
                #else
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Rectangle().fill(.thinMaterial)
                            .ignoresSafeArea()
                            .overlay {
                                HStack {
                                    Spacer()
                                    ColorPicker("Color", selection: .init(get: {
                                        if let selectedIconReplacement {
                                            return configuration.colorFor(selectedIconReplacement)
                                        } else {
                                            return .accentColor
                                        }
                                    }, set: { newValue in
                                        configuration.customColors[selectedIconReplacement!] = newValue
                                    }))
                                }
                                .padding(.horizontal, 10)
                            }
                            .frame(height: 50)
                            .overlay(alignment: .top) {
                                Divider()
                            }
                    }
                }
                #endif
            }
        }
    }
    
    var regexTable: some View {
        // TODO: Reload this when replaced course names changes
        VStack {
            #if os(iOS)
            if UIScreen.main.traitCollection.userInterfaceIdiom != .phone {
                Table(replacedCourseNames, selection: $selectedNameReplacement) {
                    TableColumn("Match Regex") { nameReplacement in
                        Text(nameReplacement.matchString)
                    }
                    TableColumn("Replacement") { nameReplacement in
                        Text(nameReplacement.replacement)
                    }
                }
            } else {
                Table(replacedCourseNames, selection: $selectedNameReplacement) {
                    TableColumn("Match Regex and Replacement") { nameReplacement in
                        HStack {
                            Text(nameReplacement.matchString)
                            Spacer()
                            Text(nameReplacement.replacement)
                        }
                    }
                }
            }
            #else
            Table(replacedCourseNames, selection: $selectedNameReplacement) {
                TableColumn("Match Regex") { nameReplacement in
                    Text(nameReplacement.matchString)
                }
                TableColumn("Replacement") { nameReplacement in
                    Text(nameReplacement.replacement)
                }
            }
            #endif
        }
        #if os(iOS)
        .navigationTitle("Regex renaming")
        .navigationBarTitleDisplayMode(.inline)
        #endif
        #if os(macOS)
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
        #else
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    guard selectedNameReplacement != nil else { return }
                    showEditPopup.toggle()
                } label: {
                    Text("Edit")
                }
                .disabled(selectedNameReplacement == nil)
            }
            
            ToolbarItem(placement: .bottomBar) {
                Text(" ")
            }
            
            ToolbarItem(placement: .bottomBar) {
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
                    .disabled(selectedNameReplacement == nil)
                    
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
                }
            }
        }
        #endif
        .onAppear {
            replacedCourseNames = configuration.replacedCourseNames
        }
        .onChange(of: configuration.replacedCourseNames) { _ in
            replacedCourseNames = configuration.replacedCourseNames
        }
        .onDisappear {
            configuration.saveToFileSystem()
            configuration.objectWillChange.send()
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
            NavigationStack {
                Form {
                    TextField("Match Regex", text: $matchString)
                    TextField("Match Text", text: $replacement)
                    Button("Save") {
                        submitChange(matchString, replacement)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                #if os(iOS)
                .navigationTitle("Edit")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
                #endif
            }
        }
    }
}

struct CustomisationView_Previews: PreviewProvider {
    static var previews: some View {
        CustomisationView()
    }
}
