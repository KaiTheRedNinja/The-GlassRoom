//
//  CreateNewPostView.swift
//  The GlassRoom
//
//  Created by Tristan on 19/05/2023.
//

import SwiftUI
import GlassRoomTypes
import GlassRoomInterface

struct CreateNewPostView: View {
    
    enum NewPostType: String, CaseIterable {
        case announcement = "Announcement"
        case coursework = "Coursework"
        case courseworkMaterial = "Coursework Material"
    }
    
    // Used by all post types
    @State var titleText = String()
    @State var descriptionText = String()
    
    // Used by only Coursework post type
    @State var dueDateAndTime = Date()
    @State var hasDueDateAndTime = false
    @State var courseWorkMaxPoints = Int()
    @State var courseWorkType: CourseWorkType = .assignment
    @State var MCQQuestions = [""]
    @State var MCQQuestionsCount = 1

    var onCreatePost: ((CoursePost) -> Void)?
    
    @State var postTypeSelection: NewPostType = .announcement
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                inputViewForPostType()
            }
            #if os(macOS)
            .frame(width: 450, height: 400)
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 0) {
                    Divider()
                    HStack {
                        viewForCancelButton()
                        Spacer()
                        viewForCreatePostButton()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    
                }
                .frame(maxWidth: .infinity)
                .background(.ultraThickMaterial)
            }
            .safeAreaInset(edge: .top) {
                VStack(spacing: 0) {
                    SegmentedControl(.init(get: {
                        switch postTypeSelection {
                        case .announcement: return 0
                        case .coursework: return 1
                        case .courseworkMaterial: return 2
                        }
                    }, set: { newValue in
                        postTypeSelection = .allCases[newValue]
                    }), options: NewPostType.allCases.map({ $0.rawValue })) { label in
                        if label == "Announcement" {
                            return "megaphone"
                        } else if label == "Coursework" {
                            return "square.and.pencil"
                        } else if label == "Coursework Material" {
                            return "doc"
                        }
                        
                        return "questionmark.circle"
                    }
                    .padding(.vertical, 10)
                    
                    Divider()
                }
                .frame(maxWidth: .infinity)
                .animation(.spring(), value: postTypeSelection)
                .background(.ultraThickMaterial)
            }
            #else
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("", selection: $postTypeSelection) {
                        Text("Announcement")
                            .tag(NewPostType.announcement)
                        Text("Coursework")
                            .tag(NewPostType.coursework)
                        Text("Material")
                            .tag(NewPostType.courseworkMaterial)
                    }
                    .pickerStyle(.segmented)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss.callAsFunction()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .keyboardShortcut(.escape)
                }
                
                ToolbarItem(placement: .status) {
                    viewForCreatePostButton()
                        .padding(.bottom)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }
    
    @ViewBuilder
    func inputViewForPostType() -> some View {
        VStack {
            switch postTypeSelection {
            case .announcement:
                inputViewForAnnouncements()
            case .coursework:
                inputViewForCourseWorks()
            case .courseworkMaterial:
                inputViewForCourseWorkMaterials()
            }
        }
    }
    
    func inputViewForAnnouncements() -> some View {
        Form {
            Section("Announcement") {
                TextEditor(text: $descriptionText)
                    .scrollContentBackground(.hidden)
                    .font(.body)
            }
        }
        .formStyle(.grouped)
    }
    
    func inputViewForCourseWorks() -> some View {
        VStack {
            Form {
                Section("Coursework") {
                    TextField("Title", text: $titleText)
                    Picker("Coursework Type", selection: $courseWorkType) {
                        ForEach(CourseWorkType.allCases, id: \.self) { type in
                            if type != .course_work_type_unspecified {
                                Text(type.rawValue.replacingOccurrences(of: "_", with: " ").capitalized)
                            }
                        }
                    }
                }
                
                Section("Description (Optional)") {
                    TextEditor(text: $descriptionText)
                        .scrollContentBackground(.hidden)
                        .font(.body)
                }
                
                
                if postTypeSelection == .coursework {
                    if courseWorkType ==  .assignment {
                        Section(header: Text(courseWorkType.rawValue.replacingOccurrences(of: "_", with: " ").capitalized)) {
                            Text("kai help thanks")
                        }
                    } else if courseWorkType == .multiple_choice_question {
                        Section {
                            ForEach(0..<MCQQuestionsCount, id: \.self) { i in
                                HStack {
                                    Button {
                                        MCQQuestions.remove(at: i)
                                        MCQQuestionsCount -= 1
                                    } label: {
                                        Image(systemName: "minus")
                                    }
                                    
                                    TextField("Choice \(i)", text: $MCQQuestions[i])
                                }
                                .tag(i)
                            }
                        } header: {
                            HStack {
                                Text(courseWorkType.rawValue.replacingOccurrences(of: "_", with: " ").capitalized)
                                
                                Spacer()
                                
                                Button {
                                    MCQQuestions.append("")
                                    MCQQuestionsCount += 1
                                } label: {
                                    Image(systemName: "plus")
                                }
                            }
                        }
                    }
                }
                
                Section("Coursework Points (Optional)") {
                    TextField("Max Points", text: Binding(
                        get: { String(courseWorkMaxPoints) },
                        set: { courseWorkMaxPoints = Int($0) ?? 0 }
                    ))
                }
                
                Section("Due Date and Time (Optional)") {
                    Toggle(isOn: $hasDueDateAndTime) {
                        Text("Enable Due Date and Time")
                    }
                    
                    if hasDueDateAndTime {
                        DatePicker("", selection: $dueDateAndTime)
                            .labelsHidden()
                            .animation(.default, value: hasDueDateAndTime)
                    }
                }
                
                Section("Additional materials (optional)") {
                    Text("Kai please help")
                }
                
                
            }
            .formStyle(.grouped)
        }
    }
    
    func inputViewForCourseWorkMaterials() -> some View {
        Form {
            Section("Coursework Material") {
                TextField("Title", text: $titleText)
                TextField("Description (Optional)", text: $descriptionText)
            }
        }
        .formStyle(.grouped)

    }
    
    func viewForCancelButton() -> some View {
        VStack {
            Button {
                dismiss.callAsFunction()
            } label: {
                Text("Cancel")
            }
            .buttonStyle(.bordered)
            .keyboardShortcut(.escape)
        }
    }
    
    func viewForCreatePostButton() -> some View {
        // TODO: - Add ability to attach materials to posts
        // TODO: - Add ability to schedule posts
        // TODO: - Add ability to assign posts to only certain students
        
        VStack {
            Button {
                switch postTypeSelection {
                case .announcement:
                    onCreatePost?(.announcement(
                        CourseAnnouncement(courseId: "",
                                           id: "",
                                           text: descriptionText,
                                           materials: nil,
                                           state: .published,
                                           alternateLink: "",
                                           creationTime: "",
                                           updateTime: "",
                                           scheduledTime: nil,
                                           assigneeMode: .all_students,
                                           individualStudentsOptions: nil,
                                           creatorUserId: ""
                                          )
                    ))
                case .coursework:
                    onCreatePost?(.courseWork(
                        CourseWork(courseId: "",
                                   id: "",
                                   title: titleText,
                                   description: descriptionText,
                                   materials: nil,
                                   state: .published,
                                   alternateLink: "",
                                   creationTime: "",
                                   updateTime: "",
                                   dueDate: hasDueDateAndTime ? convertDateToDueDate(dueDateAndTime) : nil,
                                   dueTime: hasDueDateAndTime ? convertDateToTimeOfDay(dueDateAndTime) : nil,
                                   scheduledTime: nil,
                                   maxPoints: courseWorkMaxPoints < 1 ? nil : Double(courseWorkMaxPoints),
                                   workType: courseWorkType,
                                   associatedWithDeveloper: nil,
                                   assigneeMode: .all_students,
                                   individualStudentsOptions: nil,
                                   submissionModificationMode: .modifiable_until_turned_in,
                                   creatorUserId: "",
                                   topicId: "",
                                   gradeCategory: nil,
                                   assignment: courseWorkType == .assignment ? Assignment(studentWorkFolder: DriveFolder(id: "", title: "", alternateLink: "")) : nil,
                                   multipleChoiceQuestion: courseWorkType == .multiple_choice_question ? MultipleChoiceQuestion(choices: MCQQuestions) : nil
                                  )
                    ))
                case .courseworkMaterial:
                    onCreatePost?(.courseMaterial(
                    CourseWorkMaterial(courseId: "",
                                       id: "",
                                       title: titleText,
                                       description: descriptionText,
                                       materials: nil,
                                       state: .published,
                                       alternateLink: "",
                                       creationTime: "",
                                       updateTime: "",
                                       scheduledTime: nil,
                                       assigneeMode: .all_students,
                                       individualStudentsOptions: nil,
                                       creatorUserId: "",
                                       topicId: ""
                                      )
                    ))
                }
                
                dismiss.callAsFunction()
            } label: {
                Text("Create \(postTypeSelection.rawValue)")
            }
            .buttonStyle(.borderedProminent)
            .keyboardShortcut(.return, modifiers: .command)
            .disabled(postTypeSelection == .announcement ?
                      descriptionText.isEmpty :
                        postTypeSelection == .coursework ?
                      titleText.isEmpty :
                        titleText.isEmpty
            )
        }
    }
    
    func convertDateToDueDate(_ date: Date) -> DueDate? {
        let utcDate = convertToUTC(date)
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: utcDate)
        let day = components.day
        let month = components.month
        let year = components.year
                
        return DueDate(year: year ?? 0, month: month ?? 0, day: day ?? 0)
    }
    
    func convertDateToTimeOfDay(_ date: Date) -> TimeOfDay? {
        let utcDate = convertToUTC(date)
                
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second, .nanosecond], from: utcDate)
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        let nanos = components.nanosecond
                
        return TimeOfDay(hours: hour, minutes: minute, seconds: second, nanos: nanos)
    }
    
    func convertToUTC(_ date: Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // Set the local timezone
        let localTimeZone = TimeZone.current
        dateFormatter.timeZone = localTimeZone
        
        // Get the current UTC offset
        let utcOffset = TimeZone.current.secondsFromGMT()
        
        // Calculate the UTC date
        if let utcDate = Calendar.current.date(byAdding: .second, value: -utcOffset, to: date) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let utcDateString = dateFormatter.string(from: utcDate)
            if let utcDateConverted = dateFormatter.date(from: utcDateString) {
                return utcDateConverted
            }
        }
        
        return Date()
    }
}

struct CreateNewPostView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewPostView()
    }
}
