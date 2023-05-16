//
//  CourseWorkDetailView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 15/5/23.
//

import SwiftUI
import GlassRoomAPI

struct CourseWorkDetailView: DetailViewPage {
    var textContent: Binding<String>
    var copiedLink: Binding<Bool>

    var courseWork: CourseWork

    @ObservedObject var submissionManager: CourseWorkSubmissionDataManager

    init(textContent: Binding<String>, copiedLink: Binding<Bool>, courseWork: CourseWork) {
        self.textContent = textContent
        self.copiedLink = copiedLink
        self.courseWork = courseWork

        self.submissionManager = .getManager(for: courseWork.courseId, courseWorkId: courseWork.id)
        submissionManager.loadList(bypassCache: true)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    HStack {
                        Text(courseWork.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .textSelection(.enabled)
                        Spacer()
                    }
                    viewForButtons(courseWork.alternateLink)
                }
                .padding(.top, 2)
                .padding(.bottom, 10)

                if let _ = courseWork.description {
                    Divider()
                        .padding(.bottom, 10)

                    VStack(alignment: .leading) {
                        HStack {
                            Text(.init(textContent.wrappedValue))
                                .textSelection(.enabled)
                            Spacer()
                        }
                    }
                }
                
                Spacer()

                VStack {
                    if let material = courseWork.materials {
                        Divider()
                        GeometryReader { geometry in
                            viewForMaterial(materials: material, geometry: geometry)
                        }
                    }
                }
            }
            .padding(.all)
        }
        .onAppear {
            copiedLink.wrappedValue = false
            if let description = courseWork.description {
                textContent.wrappedValue = makeLinksHyperLink(description)
            }
        }
        .onChange(of: courseWork) { _ in
            copiedLink.wrappedValue = false
            if let description = courseWork.description {
                textContent.wrappedValue = makeLinksHyperLink(description)
            }
        }
        .safeAreaInset(edge: .bottom) {
            viewForStudentSubmission
        }
    }
    
    var viewForStudentSubmission: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                ForEach(submissionManager.submissions, id: \.id) { submission in
                    studentSubmissionTypes(submission)
                }
            }
        }
    }
    
    func studentSubmissionTypes(_ submission: StudentSubmission) -> some View {
        VStack {
            if submission.courseWorkType != .course_work_type_unspecified {
                
                Divider()
                    .padding(.vertical, 5)
                
                if submission.courseWorkType == .assignment {
                    // assignment
                    VStack(alignment: .leading) {
                        HStack {
                            submissionState(submission.state)

                            Spacer()

                            Button {
                                turnInButtonPressed(submission: submission)
                            } label: {
                                buttonText(submission.state)
                            }
                        }
                        
                        if let assignmentSubmission = submission.assignmentSubmission {

                            if assignmentSubmission.attachments != nil {
                                viewForAttachment(materials: assignmentSubmission)
                                    .frame(height: 100)
                            }
                        }
                    }
                    .padding(.all)
                } else if submission.courseWorkType == .multiple_choice_question {
                    // mcq
                    Text("MCQ")
                } else if submission.courseWorkType == .short_answer_question {
                    // saq
                    Text("Short answer")
                }
            }
        }
    }

    func turnInButtonPressed(submission: StudentSubmission) {
        // TODO: Redirect them to the app
//        GlassRoomAPI.GRCourses.GRCourseWork.GRStudentSubmissions.turnInSubmission(
//            params: .init(
//                courseId: submission.courseId,
//                courseWorkId: submission.courseWorkId,
//                id: submission.id
//            ),
//            query: VoidStringCodable(),
//            data: VoidStringCodable()) { response in
//                switch response {
//                case .success(let success):
//                    print(success)
//                    return
//                case .failure(let failure):
//                    print("failure: \(failure.localizedDescription)")
//                }
//            }
    }
    
    func submissionState(_ state: SubmissionState) -> some View {
        VStack(alignment: .leading) {
            switch state {
            case .turned_in:
                Text("Submitted")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            case .reclaimed_by_student:
                Text("Unsubmitted")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
            case .returned:
                Text("Returned")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
            case .submission_state_unspecified:
                Text("Unspecified")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
            case .new:
                Text("Assigned")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            case .created:
                Text("Assigned")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
        }
    }
    
    func buttonText(_ state: SubmissionState) -> some View {
        VStack(alignment: .leading) {
            switch state {
            case .turned_in:
                Text("Unsubmit")
            case .reclaimed_by_student:
                Text("Submit")
            case .returned:
                Text("Resubmit")
            case .submission_state_unspecified:
                Text("Submit")
            case .new:
                Text("Submit")
            case .created:
                Text("Submit")
            }
        }
    }
}
