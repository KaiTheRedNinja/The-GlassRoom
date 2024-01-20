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
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack {
                            viewForButtons(link: announcement.alternateLink, post: .announcement(announcement), dividerAbove: false)
                            Spacer()
                        }
                        .padding(.top, 2)
                        #if os(macOS)
                        .padding(.bottom, 10)
                        #endif
                        #if os(macOS)
                        Divider()
                            .padding(.bottom, 10)
                        #endif
                        
                        HStack {
                            Text(LocalizedStringKey(textContent.wrappedValue))
                                .textSelection(.enabled)
                            Spacer()
                        }
                        #if os(iOS)
                        .padding(.top, 10)
                        #endif
                        
                        Spacer()
                        
                        if let material = announcement.materials {
                            Divider()
                            viewForMaterial(materials: material, size: geometry.size)
                        }
                    }
                    .padding(.all)
                }
            }
            .onAppear {
                copiedLink.wrappedValue = false
                textContent.wrappedValue = announcement.text
            }
            .onChange(of: announcement) { newAnnouncement in
                copiedLink.wrappedValue = false
                textContent.wrappedValue = newAnnouncement.text
            }
            #if os(iOS)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Announcement")
                        .fontWeight(.bold)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Link(destination: URL(string: announcement.alternateLink)!) {
                            Label("Open Post", systemImage: "safari")
                        }
                        
                        ShareLink(item: announcement.alternateLink) {
                            Label("Share Post", systemImage: "square.and.arrow.up")
                        }
                        
                        Button {
                            copiedLink.wrappedValue = true
                            let pasteboard = UIPasteboard.general
                            pasteboard.string = announcement.alternateLink
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
}
