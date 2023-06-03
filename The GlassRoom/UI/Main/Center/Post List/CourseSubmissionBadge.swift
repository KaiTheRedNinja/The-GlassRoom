//
//  CourseSubmissionBadge.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 26/5/23.
//

import SwiftUI
import GlassRoomTypes

struct CourseSubmissionBadge: View {
    var courseWork: CourseWork

    @ObservedObject var submissionsManager: CourseWorkSubmissionDataManager

    init(courseWork: CourseWork) {
        self.courseWork = courseWork
        self.submissionsManager = CourseWorkSubmissionDataManager.getManager(
            for: courseWork.courseId,
            courseWorkId: courseWork.id
        )
    }

    var body: some View {
        let submissions = submissionsManager.submissions

        ZStack {
            if submissions.count == 1,
               let submission = submissions.first {
                let submissionState = CourseSubmissionState(from: submission, courseWork: courseWork)
                Text(submissionState.description)
                    .padding(5)
                    .background {
                        submissionState.color.saturation(0.6)
                    }
            }
        }
        .font(.caption)
        .bold()
        .opacity(0.7)
        .onAppear {
            DispatchQueue.main.async {
                submissionsManager.loadList()
            }
        }
    }
}
