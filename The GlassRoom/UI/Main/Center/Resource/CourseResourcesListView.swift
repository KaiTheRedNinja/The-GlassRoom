//
//  CourseResourcesListView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 22/5/23.
//

import SwiftUI
import GlassRoomTypes

struct CourseResourcesListView: View {
    var courseMaterials: [CourseWorkMaterial]

    var isEmpty: Bool
    var isLoading: Bool
    var hasNextPage: Bool
    /// Load the list, optionally bypassing the cache
    var loadList: (_ bypassCache: Bool) -> Void
    /// Refresh, using the next page token if needed
    var refreshList: () -> Void

    var body: some View {
        ZStack {
            if !isEmpty {
                postsContent
            } else {
                VStack {
                    Text("No Resources")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                }
                .frame(maxHeight: .infinity)
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack(alignment: .center) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(.init(0.45))
                        .offset(x: -10)
                } else {
                    Button {
                        loadList(false)
                        loadList(true)
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .keyboardShortcut("r", modifiers: .command)
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button("Use Cache") {
                            loadList(true)
                        }
                    }
                    .offset(y: -1)
                }

                Spacer()
            }
            .padding(.horizontal, 5)
            .frame(height: 25)
            .frame(maxWidth: .infinity)
            .background(.thinMaterial)
            .overlay(alignment: .top) {
                VStack(spacing: 0) {
                    Divider()
                }
            }
            .padding(.top, -7)
        }
    }

    var postsContent: some View {
        List {
            CoursePostListView(postData: courseMaterials.map({ .courseMaterial($0) })) { post in AnyView(
                GroupBox {
                    VStack(alignment: .center) {
                        switch post {
                        case .courseMaterial(let material):
                            Text(material.title)
                            ForEach(material.materials ?? []) { material in
                                ZStack {
                                    if let driveFile = material.driveFile?.driveFile {
                                        LinkPreview(url: URL(string: driveFile.alternateLink)!, isAttachment: false)
                                    }

                                    if let youtubeVideo = material.youtubeVideo {
                                        LinkPreview(url: URL(string: youtubeVideo.alternateLink)!, isAttachment: false)
                                    }

                                    if let link = material.form?.formUrl {
                                        LinkPreview(url: URL(string: link)!, isAttachment: false)
                                    }

                                    if let materialLink = material.link {
                                        LinkPreview(url: URL(string: materialLink.url)!, isAttachment: false)
                                    }
                                }
                                .frame(width: 200)
                            }
                        default:
                            Text("Non material found")
                        }
                    }
                }
            )}

            if hasNextPage {
                Button("Load next page") {
                    refreshList()
                }
            }
        }
    }
}
