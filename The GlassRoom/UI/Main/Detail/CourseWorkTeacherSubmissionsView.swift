//
//  CourseWorkTeacherSubmissionsView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 23/5/23.
//

import SwiftUI
import GlassRoomTypes

struct CourseWorkTeacherSubmissionsView: View {
    var submissions: [StudentSubmission]

    @ObservedObject var profileManager: GlobalUserProfilesDataManager = .global

    @SceneStorage("searchTerm") var searchTerm: String = ""

    var body: some View {
        NavigationSplitView {
            List {
                Section("Turned In") {
                    ForEach(matchingSubmissions(submissions: submissions,
                                                state: .turned_in,
                                                searchTerm: searchTerm), id: \.id) { submission in
                        viewForSubmission(submission: submission)
                    }
                }
                Section("Assigned") {
                    ForEach(matchingSubmissions(submissions: submissions,
                                                state: .created,
                                                searchTerm: searchTerm), id: \.id) { submission in
                        viewForSubmission(submission: submission)
                    }
                }
                Section("Returned") {
                    ForEach(matchingSubmissions(submissions: submissions,
                                                state: .returned,
                                                searchTerm: searchTerm), id: \.id) { submission in
                        viewForSubmission(submission: submission)
                    }
                }
                Section("Reclaimed") {
                    ForEach(matchingSubmissions(submissions: submissions,
                                                state: .reclaimed_by_student,
                                                searchTerm: searchTerm), id: \.id) { submission in
                        viewForSubmission(submission: submission)
                    }
                }
                Section("Not Accessed") {
                    ForEach(matchingSubmissions(submissions: submissions,
                                                state: .new,
                                                searchTerm: searchTerm), id: \.id) { submission in
                        viewForSubmission(submission: submission)
                    }
                }
            }
            .safeAreaInset(edge: .top) {
                VStack {
                    TextField("Search Term", text: $searchTerm)
                        .cornerRadius(5)
                        .offset(y: 3)
                }
                .frame(height: 15)
                .padding([.horizontal, .top], 4)
                .background(.thickMaterial)
                .safeAreaInset(edge: .bottom) {
                    VStack {
                        Divider()
                    }
                    .offset(y: 8)
                }
            }
        } detail: {
            Text("HELLO THERE")
        }
        .frame(width: 600, height: 400)
    }

    func matchingSubmissions(submissions: [StudentSubmission],
                             state: SubmissionState?,
                             searchTerm: String) -> [StudentSubmission] {
        var result = submissions
        // filter by state, if available.
        if let state {
            result = result.filter({ $0.state == state })
        }

        guard !searchTerm.isEmpty else { return result }
        result = result.filter { submission in
            guard let user = profileManager.userProfilesMap[submission.userId] else {
                return true
            }
            return user.name.fullName.lowercased().contains(searchTerm.lowercased())
        }
        return result
    }

    @ViewBuilder
    func viewForSubmission(submission: StudentSubmission) -> some View {
        if let user = profileManager.userProfilesMap[submission.userId] {
            CourseRegisterItem(userProfile: user)
        } else {
            Text("Users not loaded")
        }
    }
}
