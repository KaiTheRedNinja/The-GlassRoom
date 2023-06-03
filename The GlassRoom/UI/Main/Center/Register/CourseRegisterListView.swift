//
//  CourseRegisterListView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 19/5/23.
//

import SwiftUI
import GlassRoomTypes

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
                    .keyboardShortcut("r", modifiers: .command)
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button("Use Cache") {
                            loadList(true)
                        }
                    }
                    .offset(y: -1)
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
    }

    @ObservedObject var profileManager: GlobalUserProfilesDataManager = .global

    var postsContent: some View {
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
                    CourseRegisterItem(userProfile: student)
                }
            } header: {
                HStack {
                    Text("Students: \(students.count)")
                    Spacer()
                    if students.count > 1 {
                        Button("Random") {
                            Task {
                                await randomStudent()
                            }
                        }
                    }
                }
            }

//            if hasNextPage {
//                Button("Load next page") {
//                    refreshList()
//                }
//            }
        }
    }

    func randomStudent() async {

        guard let randomStudent = students.randomElement(),
              let student = profileManager.userProfilesMap[randomStudent.userId]
        else { return }

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
    }
}
