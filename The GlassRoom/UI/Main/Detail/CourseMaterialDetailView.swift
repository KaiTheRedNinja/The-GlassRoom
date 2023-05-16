//
//  CourseMaterialDetailView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 15/5/23.
//

import SwiftUI
import GlassRoomAPI

struct CourseMaterialDetailView: DetailViewPage {
    var textContent: Binding<String>
    var copiedLink: Binding<Bool>

    var courseWorkMaterial: CourseWorkMaterial

    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(courseWorkMaterial.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .textSelection(.enabled)
                        Spacer()
                    }
                    viewForButtons(courseWorkMaterial.alternateLink)
                }
                .padding(.top, 2)
                .padding(.bottom, 10)

                if let _ = courseWorkMaterial.description {
                    Divider()
                        .padding(.bottom, 10)

                    VStack(alignment: .leading) {
                        HStack {
                            Text(textContent.wrappedValue)
                                .textSelection(.enabled)
                            Spacer()
                        }
                    }
                }

                Spacer()

                VStack {
                    if let material = courseWorkMaterial.materials {
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
            if let description = courseWorkMaterial.description {
                textContent.wrappedValue = makeLinksHyperLink(description)
            }
        }
        .onChange(of: courseWorkMaterial) { _ in
            copiedLink.wrappedValue = false
            if let description = courseWorkMaterial.description {
                textContent.wrappedValue = makeLinksHyperLink(description)
            }
        }
    }
}
