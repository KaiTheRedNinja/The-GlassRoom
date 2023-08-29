//
//  CourseWorkStudentSubmissionView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 23/5/23.
//

import SwiftUI
import GlassRoomTypes

struct CourseWorkStudentSubmissionView<AttachmentView: View>: View {
    var submission: StudentSubmission
    var courseWork: CourseWork
    var viewForAttachment: (AssignmentSubmission) -> AttachmentView

    @Environment(\.openURL) private var openURL

    var body: some View {
        if submission.courseWorkType == .assignment {
            // assignment
            viewForAssignment(submission, courseWork: courseWork)
        } else if submission.courseWorkType == .multiple_choice_question {
            // mcq
            viewForMCQ(submission, courseWork: courseWork)
        } else if submission.courseWorkType == .short_answer_question {
            // saq
            viewForShortAnswer(submission, courseWork: courseWork)
        }
    }

    func viewForAssignment(_ submission: StudentSubmission, courseWork: CourseWork) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    viewForCourseWorkDueDate(submission)

                    submissionState(submission, courseWork)

                    viewForCourseWorkGrades(submission)
                }

                Spacer()

                viewForSubmitButton(submission)
            }
            .padding(.bottom, 5)

            if let assignmentSubmission = submission.assignmentSubmission {
                if assignmentSubmission.attachments != nil {
                    viewForAttachment(assignmentSubmission)
                        .frame(height: 100)
                }
            }
        }
        .padding(.all)
    }

    func viewForShortAnswer(_ submission: StudentSubmission, courseWork: CourseWork) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    viewForCourseWorkDueDate(submission)

                    submissionState(submission, courseWork)

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

    func viewForMCQ(_ submission: StudentSubmission, courseWork: CourseWork) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    viewForCourseWorkDueDate(submission)

                    submissionState(submission, courseWork)

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
                guard let url = URL(string: "\(submission.alternateLink)?ti=1") else { return }
                openURL(url)
            } label: {
                buttonText(submission.state)
                #if os(macOS)
                    .foregroundStyle(.primary)
                #else
                    .font(.subheadline)
                    .fontWeight(.semibold)
                #endif
            }
            #if os(iOS)
            .buttonStyle(.borderedProminent)
            #endif
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

    func submissionState(_ submission: StudentSubmission, _ courseWork: CourseWork) -> some View {
        VStack(alignment: .leading) {
            switch CourseSubmissionState(from: submission, courseWork: courseWork) {
            case .assigned, .untouched:
                Text("Assigned")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.green.opacity(0.7))
            case .missing, .reclaimedMissing, .untouchedMissing:
                Text("Missing")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.red.opacity(0.7))
            case .submitted:
                Text("Submitted")
                    .font(.headline)
                    .fontWeight(.bold)
            case .turnedInLate:
                Text("Turned in late")
                    .font(.headline)
                    .fontWeight(.bold)
            case .reclaimed:
                Text("Reclaimed")
                    .font(.headline)
                    .fontWeight(.bold)
            case .returned:
                Text("Returned")
                    .font(.headline)
                    .fontWeight(.bold)
            case .unspecified:
                Text("Unspecified")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.red.opacity(0.7))
            }
        }
    }

    func buttonText(_ state: SubmissionState) -> some View {
        VStack(alignment: .leading) {
            switch state {
            case .turned_in:
                //                Text("Unsubmit")
                #if os(macOS)
                Text("Unsubmit in browser")
                #else
                Text("Unsubmit via Classroom")
                #endif
            case .reclaimed_by_student:
                //                Text("Submit")
                #if os(macOS)
                Text("Submit in browser")
                #else
                Text("Submit via Classroom")
                #endif
            case .returned:
                //                Text("Resubmit")
                #if os(macOS)
                Text("Resubmit in browser")
                #else
                Text("Resubmit via Classroom")
                #endif
            case .submission_state_unspecified:
                //                Text("Submit")
                #if os(macOS)
                Text("Submit in browser")
                #else
                Text("Submit via Classroom")
                #endif
            case .new:
                //                Text("Submit")
                #if os(macOS)
                Text("Submit in browser")
                #else
                Text("Submit via Classroom")
                #endif
            case .created:
                //                Text("Submit")
                #if os(macOS)
                Text("Submit in browser")
                #else
                Text("Submit via Classroom")
                #endif
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

enum CourseSubmissionState {
    case assigned
    case missing

    case submitted
    case turnedInLate

    case reclaimed
    case reclaimedMissing

    case untouched
    case untouchedMissing

    case returned
    case unspecified

    init(from submission: StudentSubmission, courseWork: CourseWork) {
        let state = submission.state
        self = .unspecified
        switch state {
        case .new:
            if let dueTime = courseWork.dueTime, let dueDate = courseWork.dueDate {
                self = isOverdue(dueDate, dueTime) ? .untouchedMissing : .untouched
            } else {
                self = .untouched
            }
        case .created:
            if let dueTime = courseWork.dueTime, let dueDate = courseWork.dueDate {
                self = isOverdue(dueDate, dueTime) ? .missing : .assigned
            } else {
                self = .assigned
            }
        case .turned_in:
            if let dueTime = courseWork.dueTime, let dueDate = courseWork.dueDate {
                self = isOverdue(dueDate, dueTime) ? .turnedInLate : .submitted
            } else {
                self = .submitted
            }
        case .reclaimed_by_student:
            if let dueTime = courseWork.dueTime, let dueDate = courseWork.dueDate {
                self = isOverdue(dueDate, dueTime) ? .reclaimedMissing : .reclaimed
            } else {
                self = .reclaimed
            }
        case .returned:
            self = .returned
        default: break
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

    var description: String {
        switch self {
        case .assigned, .untouched:
            return "Assigned"
        case .missing, .untouchedMissing, .reclaimedMissing:
            return "Missing"
        case .submitted:
            return "Submitted"
        case .turnedInLate:
            return "Turned In Late"
        case .reclaimed:
            return "Reclaimed"
        case .returned:
            return "Returned"
        case .unspecified:
            return "Unspecified"
        }
    }

    var color: Color {
        switch self {
        case .assigned, .untouched:
            return Color.gray
        case .missing, .untouchedMissing, .reclaimedMissing:
            return Color.red
        case .submitted:
            return Color.green
        case .turnedInLate:
            return Color.brown
        case .reclaimed:
            return Color.yellow
        case .returned:
            return Color.yellow
        case .unspecified:
            return Color.gray
        }
    }
}
