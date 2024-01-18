//
//  CourseRegisterListView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 19/5/23.
//

import SwiftUI
import GlassRoomTypes
import GlassRoomInterface
#if os(macOS)
import KeyboardShortcuts
#endif

struct CourseRegisterListView: View {
    var teachers: [GlobalUserProfilesDataManager.TeacherReference]
    var students: [GlobalUserProfilesDataManager.StudentReference]

    var isEmpty: Bool
    var isLoading: Bool
    var hasNextPage: Bool
    /// Load the list, optionally bypassing the cache
    var loadList: (_ bypassCache: Bool) -> Void
    /// Refresh, using the next page token if needed
    var refreshList: () -> Void
    
    @State var showingAlert = false
    @State var randomName = ""
    #if os(iOS)
    @State var randomImage = UIImage()
    #else
    @State var randomImage = NSImage()
    #endif

    var body: some View {
        ZStack {
            if !isEmpty {
                postsContent
            } else {
                VStack {
                    Text("No Users")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                }
                .frame(maxHeight: .infinity)
            }
        }
        #if os(macOS)
        .safeAreaInset(edge: .bottom) {
            HStack(alignment: .center) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(.init(0.45))
                        .offset(x: -10)
                } else {
                    Button {
                        loadList(false)
                        loadList(true)
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
//                    .onKeyboardShortcut(.reloadCoursePosts, type: .keyDown) {
//                        loadList(false)
//                        loadList(true)
//                    }
                    .keyboardShortcut("r", modifiers: [.command])
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button("Use Cache") {
                            loadList(true)
                        }
                    }
                    .offset(y: -1)
                    .help("Refresh Posts (⌘R)")
                }

                Spacer()
            }
            .padding(.horizontal, 5)
            .frame(height: 25)
            .frame(maxWidth: .infinity)
            .background(.thinMaterial)
            .overlay(alignment: .top) {
                VStack(spacing: 0) {
                    Divider()
                }
            }
            .padding(.top, -7)
        }
        #else
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else {
                    Button {
                        loadList(false)
                        loadList(true)
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .keyboardShortcut("r", modifiers: .command)
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button("Use Cache") {
                            loadList(true)
                        }
                    }
                    .help("Refresh Posts (⌘R)")
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                Text(" ")
            }
        }
        #endif
    }

    @ObservedObject var profileManager: GlobalUserProfilesDataManager = .global

    @State var attendanceMode: Bool = false
    @State var attendances: [String: TriToggleState] = [:]

    var postsContent: some View {
        ZStack {
            List {
                Section("Teachers: \(teachers.count)") {
                    let teachersMapped = teachers.compactMap({ profileManager.userProfilesMap[$0.userId] })
                    ForEach(teachersMapped.sorted(by: { $0.name.fullName < $1.name.fullName }), id: \.id) { teacher in
                        CourseRegisterItem(userProfile: teacher)
                    }
                }
                
                Section {
                    let studentsMapped = students.compactMap({ profileManager.userProfilesMap[$0.userId] })
                    ForEach(studentsMapped.sorted(by: { $0.name.fullName < $1.name.fullName }), id: \.id) { student in
                        HStack {
                            if attendanceMode {
                                TriStateToggle(toggleState: .init(get: {
                                    attendances[student.id] ?? .middle
                                }, set: { newValue in
                                    attendances[student.id] = newValue
                                }))
                            }
                            CourseRegisterItem(userProfile: student)
                        }
                    }
                    if attendanceMode {
                        Menu("Export Attendance Sheet") {
                            Button("Sorted by Attendance") {
                                exportStudents(sortStyle: .attendanceSorted)
                            }
                            Button("Sorted by Student Name") {
                                exportStudents(sortStyle: .studentSorted)
                            }
                        }
                        .buttonStyle(.borderless)
                    }
                } header: {
                    HStack {
                        Text("Students: \(students.count)")
                        Spacer()
                        if students.count > 1 {
                            Button {
                                Task {
                                    await randomStudent()
                                }
                            } label: {
                                Image(systemName: "dice")
                            }
                            
                            Button {
                                attendanceMode.toggle()
                            } label: {
                                Image(systemName: "checklist")
                            }
                        }
                    }
                } footer: {
                    Text("Glassroom is only able to display every student in the Register if you are a teacher in the class due to Google's API restrictions.")
                        .padding(.vertical, 5)
                }
            }
            #if os(iOS)
            .alert("\(randomName)", isPresented: $showingAlert) {
                Button("Pick again") {
                    Task {
                        await randomStudent()
                    }
                }
                Button("OK", role: .cancel) { }
            }
            #endif
        }
    }

    func randomStudent() async {

        guard let randomStudent = students.randomElement(),
              let student = profileManager.userProfilesMap[randomStudent.userId]
        else { return }

        #if os(macOS)
        let alert = NSAlert.init()
        alert.messageText = student.name.fullName
        if let photoUrl = student.photoUrl {
            let urlRequest = URLRequest(url: URL(string: "https:" + photoUrl)!)
            let response = try? await URLSession.shared.data(for: urlRequest)
            if let data = response?.0 {
                alert.icon = NSImage(data: data)
            }
        }
        alert.runModal()
        #else
        // TODO: Implement for iOS
        randomName = student.name.fullName
        if let photoUrl = student.photoUrl {
            let urlRequest = URLRequest(url: URL(string: "https:" + photoUrl)!)
            let response = try? await URLSession.shared.data(for: urlRequest)
            if let data = response?.0 {
                randomImage = UIImage(data: data) ?? UIImage()
            }
        }
        showingAlert = true
        #endif
    }

    enum ExportSortStyle {
        case attendanceSorted
        case studentSorted
    }
    func exportStudents(sortStyle: ExportSortStyle) {
        let studentsMapped = students.compactMap({ profileManager.userProfilesMap[$0.userId] })
        let attendanceTuples = studentsMapped
            .map { profile in
                return (profile.name.fullName, attendances[profile.id] ?? .middle)
            }
        let attendanceSorted: [(String, TriToggleState)]

        switch sortStyle {
        case .attendanceSorted:
            attendanceSorted = attendanceTuples
                .sorted { lhs, rhs in
                    if lhs.1 == rhs.1 {
                        return lhs.0 < rhs.0
                    } else {
                        return lhs.1.rawValue < rhs.1.rawValue
                    }
                }
        case .studentSorted:
            attendanceSorted = attendanceTuples
                .sorted { lhs, rhs in
                    lhs.0 < rhs.0
                }
        }

        let attendanceString = attendanceSorted
            .map {
                switch $0.1 {
                case .middle: return "\($0.0), UNMARKED"
                case .on: return "\($0.0), PRESENT"
                case .off: return "\($0.0), ABSENT"
                }
            }
            .joined(separator: "\n")

        // write it to a file
        #if os(macOS)
        guard let nsWindow = NSApplication.shared.keyWindow else {
            Log.error("No keywindow found")
            return
        }
        let panel = NSSavePanel()
        panel.nameFieldStringValue = "attendance.csv"
        panel.beginSheetModal(for: nsWindow) { response in
            guard response.rawValue == 1,
                  let url = panel.url,
                  let data = attendanceString.data(using: .utf8)
            else { return }

            do {
                try data.write(to: url)
                return
            } catch {
                // failed to write file – bad permissions, bad filename,
                // missing permissions, or more likely it can't be converted to the encoding
                Log.error(error.localizedDescription)
            }
        }
        #else
        // TODO: Figure out how to save files on iOS
        #endif
    }
}
