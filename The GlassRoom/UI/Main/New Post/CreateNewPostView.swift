//
//  CreateNewPostView.swift
//  The GlassRoom
//
//  Created by Tristan on 19/05/2023.
//

import SwiftUI
import GlassRoomTypes

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

    var onCreatePost: ((CoursePost) -> Void)?
    
    @State var postTypeSelection: NewPostType = .announcement
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            inputViewForPostType()
        }
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
                Section {
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
            }
            .formStyle(.grouped)
        }
    }
    
    func inputViewForCourseWorkMaterials() -> some View {
        Form {
            TextField("Title", text: $titleText)
            TextField("Description (Optional)", text: $descriptionText)
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
                                           scheduledTime: "",
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
                                   dueDate: convertDateToDueDate(dueDateAndTime),
                                   dueTime: convertDateToTimeOfDay(dueDateAndTime),
                                   scheduledTime: "",
                                   maxPoints: courseWorkMaxPoints < 1 ? nil : Double(courseWorkMaxPoints),
                                   workType: courseWorkType,
                                   associatedWithDeveloper: nil,
                                   assigneeMode: .all_students,
                                   individualStudentsOptions: nil,
                                   submissionModificationMode: .modifiable_until_turned_in,
                                   creatorUserId: "",
                                   topicId: "",
                                   gradeCategory: nil,
                                   assignment: nil,
                                   multipleChoiceQuestion: nil
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
                                       scheduledTime: "",
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
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let day = components.day
        let month = components.month
        let year = components.year
        
        print("asad \(DueDate(year: year ?? 0, month: month ?? 0, day: day ?? 0))")
        
        return DueDate(year: year ?? 0, month: month ?? 0, day: day ?? 0)
    }
    
    func convertDateToTimeOfDay(_ date: Date) -> TimeOfDay? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        print("asad \(TimeOfDay(hours: hour, minutes: minute, seconds: second))")
        
        return TimeOfDay(hours: hour, minutes: minute, seconds: second, nanos: 1)
    }
    
}

struct CreateNewPostView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewPostView()
    }
}
