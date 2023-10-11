//
//  CourseMaterialDetailView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 15/5/23.
//

import SwiftUI
import GlassRoomTypes

struct CourseMaterialDetailView: DetailViewPage {
    var textContent: Binding<String>
    var copiedLink: Binding<Bool>

    var courseWorkMaterial: CourseWorkMaterial

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
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
                            viewForButtons(link: courseWorkMaterial.alternateLink, post: .courseMaterial(courseWorkMaterial), dividerAbove: true)
#if os(iOS)
                                .padding(.top, 5)
#endif
                        }
                        .padding(.top, 2)
                        .padding(.bottom, 10)
                        
                        if let _ = courseWorkMaterial.description {
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
                            if let material = courseWorkMaterial.materials {
                                Divider()
                                viewForMaterial(materials: material, size: geometry.size)
                            }
                        }
                    }
                    .padding(.all)
                }
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
            #if os(iOS)
            .toolbar {
                if UIDevice().userInterfaceIdiom == .phone {
                    ToolbarItem(placement: .principal) {
                        Text("Material")
                            .fontWeight(.bold)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Link(destination: URL(string: courseWorkMaterial.alternateLink)!) {
                            Label("Open Post", systemImage: "safari")
                        }
                        
                        ShareLink(item: courseWorkMaterial.alternateLink) {
                            Label("Share Post", systemImage: "square.and.arrow.up")
                        }
                        
                        Button {
                            copiedLink.wrappedValue = true
                            let pasteboard = UIPasteboard.general
                            pasteboard.string = courseWorkMaterial.alternateLink
                        } label: {
                            Label("Copy Post link", systemImage: "link")
                        }
                        
                        Divider()
                        
                        OpenNotesButton(post: .courseMaterial(courseWorkMaterial))
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            #endif
        }
    }
}
