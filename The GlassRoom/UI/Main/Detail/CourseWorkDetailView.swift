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

    @ObservedObject var submissionManager: CourseWorkSubmissionDataManager
    @State var showSubmissionsView: Bool = false

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
        .sheet(isPresented: $showSubmissionsView) {
            CourseWorkTeacherSubmissionsView(submissions: submissionManager.submissions)
        }
    }

    @ViewBuilder
    var viewForStudentSubmission: some View {
        if submissionManager.submissions.count <= 1, let submission = submissionManager.submissions.first {
            // student view
            CourseWorkStudentSubmissionView(submission: submission,
                                            courseWork: courseWork,
                                            viewForAttachment: viewForAttachment)
        } else {
            // teacher view
            HStack {
                GroupBox {
                    VStack {
                        HStack {
                            Text("Assigned: \(submissionManager.submissions.filter({ $0.state != .turned_in }).count)")
                            Text("Turned In: \(submissionManager.submissions.filter({ $0.state == .turned_in }).count)")
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
}
