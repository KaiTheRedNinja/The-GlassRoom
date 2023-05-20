//
//  AnnouncementDetailView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 15/5/23.
//

import SwiftUI
import GlassRoomTypes

struct AnnouncementDetailView: DetailViewPage {
    var textContent: Binding<String>
    var copiedLink: Binding<Bool>

    var announcement: CourseAnnouncement

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        viewForButtons(announcement.alternateLink)
                        Spacer()
                    }
                    .padding(.top, 2)
                    .padding(.bottom, 10)

                    Divider()
                        .padding(.bottom, 10)

                    HStack {
                        Text(.init(textContent.wrappedValue))
                            .textSelection(.enabled)
                        Spacer()
                    }

                    Spacer()

                    if let material = announcement.materials {
                        Divider()
                        viewForMaterial(materials: material, geometry: geometry)
                    }
                }
                .padding(.all)
            }
        }
        .onAppear {
            copiedLink.wrappedValue = false
            textContent.wrappedValue = makeLinksHyperLink(announcement.text)
        }
        .onChange(of: announcement) { newAnnouncement in
            copiedLink.wrappedValue = false
            textContent.wrappedValue = makeLinksHyperLink(newAnnouncement.text)
        }
    }
}
