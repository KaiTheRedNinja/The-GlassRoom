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

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    HStack {
                        Text(courseWork.title)
                            .font(.title2)
                            .fontWeight(.bold)

                        Spacer()

                        viewForButtons(courseWork.alternateLink)
                    }
                    .padding(.top, 2)
                    .padding(.bottom, 10)

                    if let _ = courseWork.description {
                        Divider()
                            .padding(.bottom, 10)

                        VStack(alignment: .leading) {
                            HStack {
                                Text(textContent.wrappedValue)
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

//            let manager = CourseWorkSubmissionDataManager.getManager(for: courseWork.courseId, courseWorkId: courseWork.id)
//            manager.refreshList()
        }
        .onChange(of: courseWork) { _ in
            copiedLink.wrappedValue = false
            if let description = courseWork.description {
                textContent.wrappedValue = makeLinksHyperLink(description)
            }
        }
    }
}
