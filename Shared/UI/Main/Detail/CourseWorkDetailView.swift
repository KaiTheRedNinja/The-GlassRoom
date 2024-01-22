//
//  CourseWorkDetailView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 15/5/23.
//

import SwiftUI
import GlassRoomTypes
import GlassRoomInterface

struct CourseWorkDetailView: DetailViewPage {
    var textContent: Binding<String>
    var copiedLink: Binding<Bool>
    
    var courseWork: CourseWork
    
    @ObservedObject var courseManager: GlobalCoursesDataManager = .global
    @ObservedObject var submissionManager: CourseWorkSubmissionDataManager
    @State var showSubmissionsView: Bool = false
    
    @State var studentSubmissionSize: CGSize?
    @State var studentSubmissionOffset: CGFloat = 0
    
    init(textContent: Binding<String>, copiedLink: Binding<Bool>, courseWork: CourseWork) {
        self.textContent = textContent
        self.copiedLink = copiedLink
        self.courseWork = courseWork
        
        self.submissionManager = .getManager(for: courseWork.courseId, courseWorkId: courseWork.id)
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    FittingGeometryReader(spaceName: "detailScrollView") { proxy in
                        content(size: geometry.size)
                            .onAppear {
                                guard let value = proxy?.frame(in: .named("detailScrollView")),
                                      let studentSubmissionSize
                                else { return }
                                studentSubmissionOffset = calculateStudentSubmissionOffset(
                                    submissionSize: studentSubmissionSize,
                                    pageSize: geometry.size,
                                    scrollFrame: value
                                )
                            }
                            .onChange(of: proxy?.frame(in: .named("detailScrollView"))) { value in
                                if let value, let studentSubmissionSize {
                                    studentSubmissionOffset = calculateStudentSubmissionOffset(
                                        submissionSize: studentSubmissionSize,
                                        pageSize: geometry.size,
                                        scrollFrame: value
                                    )
                                }
                            }
                    }
                }
            }
            .coordinateSpace(name: "detailScrollView")
            .onAppear {
                DispatchQueue.main.async {
                    submissionManager.loadList(bypassCache: true)
                    copiedLink.wrappedValue = false
                    if let description = courseWork.description {
                        textContent.wrappedValue = description
                    }
                }
            }
            .onChange(of: courseWork) { _ in
                copiedLink.wrappedValue = false
                if let description = courseWork.description {
                    textContent.wrappedValue = description
                }
            }
            .safeAreaInset(edge: .bottom) {
                FittingGeometryReader { proxy in
                    viewForStudentSubmission
                        .background(.thickMaterial)
                        .onAppear {
                            studentSubmissionSize = proxy?.size
                        }
                        .onChange(of: proxy?.size) { newVal in
                            studentSubmissionSize = newVal
                        }
                        .offset(y: studentSubmissionOffset)
                        .animation(.default, value: studentSubmissionOffset)
                }
            }
            .sheet(isPresented: $showSubmissionsView) {
                CourseWorkTeacherSubmissionsView(submissions: submissionManager.submissions,
                                                 courseWork: courseWork,
                                                 viewForAttachment: viewForAttachment)
            }
            #if os(iOS)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Coursework")
                        .fontWeight(.bold)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Link(destination: URL(string: courseWork.alternateLink)!) {
                            Label("Open Post", systemImage: "safari")
                        }
                        
                        ShareLink(item: courseWork.alternateLink) {
                            Label("Share Post", systemImage: "square.and.arrow.up")
                        }
                        
                        Button {
                            copiedLink.wrappedValue = true
                            let pasteboard = UIPasteboard.general
                            pasteboard.string = courseWork.alternateLink
                        } label: {
                            Label("Copy Post link", systemImage: "link")
                        }
                        
                        Divider()
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            #endif
        }
    }

    func content(size: CGSize) -> some View {
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
                
                viewForButtons(link: courseWork.alternateLink, post: .courseWork(courseWork), dividerAbove: true)
                #if os(iOS)
                    .padding(.top, 5)
                #endif
            }
            .padding(.top, 2)
            .padding(.bottom, 10)

            if let _ = courseWork.description {
                Divider()
                    .padding(.bottom, 10)

                VStack(alignment: .leading) {
                    HStack {
                        Text(LocalizedStringKey(textContent.wrappedValue))
                            .textSelection(.enabled)
                        Spacer()
                    }
                }
            }

            Spacer()

            VStack {
                if let material = courseWork.materials {
                    Divider()
                    viewForMaterial(materials: material, size: size)
                }
            }
        }
        .padding(.all)
    }

    @ViewBuilder
    var viewForStudentSubmission: some View {
        if submissionManager.submissions.count <= 1, let submission = submissionManager.submissions.first, getUserRole() == .enrolled {
            // student view
            VStack {
                if submission.courseWorkType != .course_work_type_unspecified {
                    Divider()
                    CourseWorkStudentSubmissionView(submission: submission,
                                                    courseWork: courseWork,
                                                    viewForAttachment: viewForAttachment)
                }
            }
        } else {
            // teacher view
            HStack {
                GroupBox {
                    VStack {
                        HStack {
                            Text("Turned In: \(submissionManager.submissions.filter({ $0.state == .turned_in }).count)")
                            Text("Assigned: \(submissionManager.submissions.filter({ $0.state != .turned_in }).count)")
                        }
                        HStack(spacing: 0) {
                            ForEach(submissionManager.submissions.filter({ $0.state == .turned_in }), id: \.id) { submission in
                                Color.green
                            }
                            ForEach(submissionManager.submissions.filter({ $0.state != .turned_in }), id: \.id) { submission in
                                Color.gray
                            }
                        }
                        .frame(height: 10)
                        .cornerRadius(5)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(10)
                Spacer()
                Button {
                    showSubmissionsView.toggle()
                } label: {
                    Image(systemName: "square.grid.2x2")
                }
                .padding(10)
                .padding(.leading, -10)
            }
        }
    }
    
    func getUserRole() -> Course.CourseType? {
        var returnResult: Course.CourseType?
        courseManager.courses.forEach { course in
            if course.id == courseWork.courseId {
                returnResult = course.courseType
            }
        }
        
        return returnResult
    }

    func calculateStudentSubmissionOffset(submissionSize: CGSize,
                                          pageSize: CGSize,
                                          scrollFrame: CGRect) -> CGFloat {
        // the top of the submission should not be any lower than 100px from the bottom,
        // or so high as to leave a gap at the bottom.
        let maximumOffset = submissionSize.height-100
        let proposedOffset = scrollFrame.maxY-pageSize.height

        return max(0, min(maximumOffset, proposedOffset))
    }
}
