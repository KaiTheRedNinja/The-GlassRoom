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
                switch CourseSubmissionState(from: submission, courseWork: courseWork) {
                case .assigned, .untouched:
                    Color.gray.saturation(0.6)
                    Image(systemName: "checklist.unchecked").resizable().scaledToFit().padding(2)
                case .missing, .untouchedMissing, .reclaimedMissing:
                    Color.red.saturation(0.6)
                    Image(systemName: "exclamationmark.square").resizable().scaledToFit().padding(2)
                case .submitted:
                    Color.green.saturation(0.6)
                    Image(systemName: "checklist.checked").resizable().scaledToFit().padding(2)
                case .turnedInLate:
                    Color.brown.saturation(0.6)
                    Image(systemName: "checklist").resizable().scaledToFit().padding(2) // might want to change this
                case .reclaimed:
                    Color.yellow.saturation(0.6)
                    Image(systemName: "arrow.uturn.left").resizable().scaledToFit().padding(2)
                case .returned:
                    Color.yellow.saturation(0.6)
                    Image(systemName: "return").resizable().scaledToFit().padding(2)
                case .unspecified:
                    Color.gray.saturation(0.6)
                    Image(systemName: "questionmark.app.dashed").resizable().scaledToFit().padding(2)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                submissionsManager.loadList()
            }
        }
    }
}
