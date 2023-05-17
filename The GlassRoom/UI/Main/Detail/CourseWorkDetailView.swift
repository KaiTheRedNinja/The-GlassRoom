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
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading) {
                                if let dueDate = courseWork.dueDate {
                                    HStack {
                                        Image(systemName: "calendar")
                                        if let dueTime = courseWork.dueTime {
                                            Text("\(dueDate.day)/\(dueDate.month)/\(dueDate.year) - \(getTimeFromDueTime(dueTime))".replacingOccurrences(of: ",", with: ""))
                                        } else {
                                            Text("\(dueDate.day)/\(dueDate.month)/\(dueDate.year)".replacingOccurrences(of: ",", with: ""))
                                        }
                                    }
                                    .lineLimit(1)
                                    .font(.headline)
                                    .foregroundColor(isSubmitted(submission.state) ? .secondary : .primary)
                                    .padding(.bottom, 5)
                                }
                                
                                submissionState(submission, submission.state)
                                
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

                            Spacer()

//                            Button {
//                                turnInButtonPressed(submission: submission)
//                            } label: {
//                                buttonText(submission.state)
//                            }
                            
                            Button {
                                guard let url = URL(string: submission.alternateLink) else { return }
                                openURL(url)
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

    func turnInButtonPressed(submission: StudentSubmission) {        
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
            let string = "00:\(minutes)"
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
        let string = "\((hours + 8) % 24):\(minutes)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.date(from: string)
        
        return string
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
        
        let string = dueString

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "d/M/yyyy - HH:mm"

        dateFormatter.date(from: string)
        
        if let duedateDate = dateFormatter.date(from: string) {
            if duedateDate > Date.now {
                return false
            } else {
                return true
            }
        }
        return false
    }
}
