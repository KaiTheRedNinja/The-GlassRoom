//
//  CourseWorkDetailView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 15/5/23.
//

import SwiftUI
import GlassRoomTypes

struct CourseWorkDetailView: DetailViewPage {
    var textContent: Binding<String>
    var copiedLink: Binding<Bool>

    var courseWork: CourseWork
    
    @Environment(\.openURL) private var openURL

    @ObservedObject var submissionManager: CourseWorkSubmissionDataManager

    init(textContent: Binding<String>, copiedLink: Binding<Bool>, courseWork: CourseWork) {
        self.textContent = textContent
        self.copiedLink = copiedLink
        self.courseWork = courseWork

        self.submissionManager = .getManager(for: courseWork.courseId, courseWorkId: courseWork.id)
        submissionManager.loadList(bypassCache: true)
    }

    var body: some View {
        GeometryReader { geometry in
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
                            viewForMaterial(materials: material, geometry: geometry)
                        }
                    }
                }
                .padding(.all)
            }
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
                .background(.thickMaterial)
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
                
                if submission.courseWorkType == .assignment {
                    // assignment
                    viewForAssignment(submission)
                } else if submission.courseWorkType == .multiple_choice_question {
                    // mcq
                    viewForMCQ(submission)
                } else if submission.courseWorkType == .short_answer_question {
                    // saq
                    viewForShortAnswer(submission)
                }
            }
        }
    }
    
    func viewForAssignment(_ submission: StudentSubmission) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    viewForCourseWorkDueDate(submission)
                    
                    submissionState(submission, submission.state)
                    
                    viewForCourseWorkGrades(submission)
                }

                Spacer()
                
                viewForSubmitButton(submission)
            }
            .padding(.bottom, 5)
            
            if let assignmentSubmission = submission.assignmentSubmission {
                if assignmentSubmission.attachments != nil {
                    viewForAttachment(materials: assignmentSubmission)
                        .frame(height: 100)
                }
            }
        }
        .padding(.all)
    }
    
    func viewForShortAnswer(_ submission: StudentSubmission) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    viewForCourseWorkDueDate(submission)
                    
                    submissionState(submission, submission.state)
                    
                    viewForCourseWorkGrades(submission)
                }

                Spacer()
                
                viewForSubmitButton(submission)
            }
            .padding(.bottom, 5)
            
            if let shortAnswerSubmission = submission.shortAnswerSubmission {
                GroupBox {
                    VStack {
                        if let shortAnswer = shortAnswerSubmission.answer {
                            Text(shortAnswer)
                        }
                    }
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.all, 5)
                }
            }
        }
        .padding(.all)
    }
    
    func viewForMCQ(_ submission: StudentSubmission) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    viewForCourseWorkDueDate(submission)
                    
                    submissionState(submission, submission.state)
                    
                    viewForCourseWorkGrades(submission)
                }
                
                Spacer()
                
                viewForSubmitButton(submission)
            }
            .padding(.bottom, 5)
            
            if let multipleChoiceSubmission = submission.multipleChoiceSubmission {
                if let mcquestions = courseWork.multipleChoiceQuestion {
                    ForEach(mcquestions.choices, id: \.self) { choice in
                        GroupBox {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .opacity(choice == multipleChoiceSubmission.answer ? 1 : 0)
                                
                                Text(choice)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.all, 5)
                        }
                    }
                }
            }
        }
        .padding(.all)
    }
    
    func viewForSubmitButton(_ submission: StudentSubmission) -> some View {
        VStack {
            Button {
                guard let url = URL(string: submission.alternateLink) else { return }
                openURL(url)
            } label: {
                buttonText(submission.state)
            }
        }
    }
    
    func viewForCourseWorkDueDate(_ submission: StudentSubmission) -> some View {
        VStack {
            if let dueDate = courseWork.dueDate {
                HStack {
                    Image(systemName: "calendar")
                    if let dueTime = courseWork.dueTime {
                        Text("\(getDateFromDueDate(dueDate)) - \(getTimeFromDueTime(dueTime))".replacingOccurrences(of: ",", with: ""))
                    } else {
                        Text("\(getDateFromDueDate(dueDate))".replacingOccurrences(of: ",", with: ""))
                    }
                }
                .lineLimit(1)
                .font(.headline)
                .foregroundColor(isSubmitted(submission.state) ? .secondary : .primary)
                .padding(.bottom, 5)
            }
        }
    }
    
    func viewForCourseWorkGrades(_ submission: StudentSubmission) -> some View {
        VStack {
            if let gradeUpon = courseWork.maxPoints {
                if let grade = submission.assignedGrade {
                    viewForGrades(grade, gradeUpon)
                        .font(.subheadline)
                } else {
                    Text("^[\(Int(gradeUpon)) \("point")](inflect: true)")
                        .font(.subheadline)
                }
            }
        }
    }
    
    func viewForGrades(_ grade: Double, _ gradeUpon: Double) -> some View {
        HStack {
            Text("\(grade.formatted())/\(gradeUpon.formatted())")
            Text("(\(calculatePercentage(grade, gradeUpon))%)")
        }
    }
    
    func calculatePercentage(_ grade: Double, _ gradeUpon: Double) -> String {
        let percentage = grade / gradeUpon * 100
        return (round(100 * percentage) / 100).formatted()
    }
    
    func submissionState(_ submission: StudentSubmission, _ state: SubmissionState) -> some View {
        VStack(alignment: .leading) {
            switch state {
            case .turned_in:
                if let late = submission.late {
                    if late {
                        Text("Turned in late")
                            .font(.headline)
                            .fontWeight(.bold)
                    } else {
                        Text("Submitted")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                } else {
                    Text("Submitted")
                        .font(.headline)
                        .fontWeight(.bold)
                }
            case .reclaimed_by_student:
                if let dueTime = courseWork.dueTime {
                    if let dueDate = courseWork.dueDate {
                        Text(isOverdue(dueDate, dueTime) ? "Missing" : "Assigned")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(isOverdue(dueDate, dueTime) ? .red.opacity(0.7) : .green.opacity(0.7))
                    } else {
                        Text("Assigned")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.green.opacity(0.7))
                    }
                } else {
                    Text("Assigned")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.green.opacity(0.7))
                }
            case .returned:
                Text("Returned")
                    .font(.headline)
                    .fontWeight(.bold)
            case .submission_state_unspecified:
                Text("Unspecified")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.red.opacity(0.7))
            case .new:
                if let dueTime = courseWork.dueTime {
                    if let dueDate = courseWork.dueDate {
                        Text(isOverdue(dueDate, dueTime) ? "Missing" : "Assigned")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(isOverdue(dueDate, dueTime) ? .red.opacity(0.7) : .green.opacity(0.7))
                    } else {
                        Text("Assigned")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.green.opacity(0.7))
                    }
                } else {
                    Text("Assigned")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.green.opacity(0.7))
                }
            case .created:
                if let dueTime = courseWork.dueTime {
                    if let dueDate = courseWork.dueDate {
                        Text(isOverdue(dueDate, dueTime) ? "Missing" : "Assigned")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(isOverdue(dueDate, dueTime) ? .red.opacity(0.7) : .green.opacity(0.7))
                    } else {
                        Text("Assigned")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.green.opacity(0.7))
                    }
                } else {
                    Text("Assigned")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.green.opacity(0.7))
                }
            }
        }
    }
    
    func buttonText(_ state: SubmissionState) -> some View {
        VStack(alignment: .leading) {
            switch state {
            case .turned_in:
//                Text("Unsubmit")
                Text("Unsubmit in browser")
                    .foregroundColor(.primary)
            case .reclaimed_by_student:
//                Text("Submit")
                Text("Submit in browser")
                    .foregroundColor(.primary)
            case .returned:
//                Text("Resubmit")
                Text("Resubmit in browser")
                    .foregroundColor(.primary)
            case .submission_state_unspecified:
//                Text("Submit")
                Text("Submit in browser")
                    .foregroundColor(.primary)
            case .new:
//                Text("Submit")
                Text("Submit in browser")
                    .foregroundColor(.primary)
            case .created:
//                Text("Submit")
                Text("Submit in browser")
                    .foregroundColor(.primary)
            }
        }
    }
    
    func getTimeFromDueTime(_ dueTime: TimeOfDay) -> String {
        guard let hours = dueTime.hours else {
            guard let minutes = dueTime.minutes else { return "-" } // no time
            // only minutes
            let string = "00:\(String(format: "%02d", minutes))"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.date(from: string)
            
            return string
        }
        guard let minutes = dueTime.minutes else {
            // only hours
            let string = "\((hours + 8) % 24):00"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.date(from: string)
            
            return string
            
        }
        
        // hours and minutes
        let string = "\((hours + 8) % 24):\(String(format: "%02d", minutes))"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.date(from: string)
        
        return string
    }
    
    func getDateFromDueDate(_ dueDate: DueDate) -> String {
        let dueString = "\(dueDate.day)/\(dueDate.month)/\(dueDate.year)"
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "d/M/yyyy"
        let date = dateFormatter.date(from: dueString)
        
        if let nonNilDate = date {
            return nonNilDate.formatted(.dateTime.day().month().year())
        } else {
            return dueString
        }
    }
    
    func isSubmitted(_ state: SubmissionState) -> Bool {
        switch state {
        case .submission_state_unspecified:
            return false
        case .new:
            return false
        case .created:
            return false
        case .turned_in:
            return true
        case .returned:
            return true
        case .reclaimed_by_student:
            return false
        }
    }
    
    func isOverdue(_ dueDate: DueDate, _ dueTime: TimeOfDay) -> Bool {
        let twentyFourHourTime = getTimeFromDueTime(dueTime)
        let dueString = "\(dueDate.day)/\(dueDate.month)/\(dueDate.year) - \(twentyFourHourTime)"
        
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "d/M/yyyy - HH:mm"

        dateFormatter.date(from: dueString)
        
        if let duedateDate = dateFormatter.date(from: dueString) {
            if duedateDate > Date.now {
                return false
            } else {
                return true
            }
        }
        return false
    }
}
