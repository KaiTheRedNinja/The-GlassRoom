//
//  CourseResourcesListView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 22/5/23.
//

import SwiftUI
import GlassRoomTypes
import GlassRoomInterface
#if os(macOS)
import KeyboardShortcuts
#endif

struct CourseResourcesListView: View {
    
    @Binding var currentPage: CourseDisplayOption
    
    var courseMaterials: [CourseWorkMaterial]

    var course: Course?
    var isEmpty: Bool
    var isLoading: Bool
    var hasNextPage: Bool
    /// Load the list, optionally bypassing the cache
    var loadList: (_ bypassCache: Bool) -> Void
    /// Refresh, using the next page token if needed
    var refreshList: () -> Void
    
    @ObservedObject var postsManager: CoursePostsDataManager
    @ObservedObject var profilesManager: GlobalUserProfilesDataManager = .global
    @ObservedObject var configuration: CoursesConfiguration = .global

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
        #if os(macOS)
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
                    .keyboardShortcut("r", modifiers: [.command])
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button("Use Cache") {
                            loadList(true)
                        }
                    }
                    .offset(y: -1)
                    .help("Refresh Posts (⌘R)")
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
        #else
        .refreshable {
            loadList(false)
            loadList(true)
        }
        .toolbar {
            if UIScreen.main.traitCollection.userInterfaceIdiom == .pad {
                ToolbarItem(placement: .bottomBar) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
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
                    }
                }
                
                ToolbarItem(placement: .status) {
                    if let course = self.course {
                        Text(configuration.nameFor(course))
                            .multilineTextAlignment(.center)
                            .font(.headline)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .padding(.horizontal, 30)
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    //                if isInSearch {
                    //                    Text(" ")
                    //                } else {
                    //                    if let onPlusPress {
                    //                        Button {
                    //                            onPlusPress()
                    //                        } label: {
                    //                            Image(systemName: "plus")
                    //                        }
                    //                        .buttonStyle(.plain)
                    //                    }
                    //                }
                    Text(" ")
                }
            } else {
                ToolbarItem(placement: .principal) {
                    if let course = self.course {
                        Text(configuration.nameFor(course))
                            .multilineTextAlignment(.center)
                            .font(.headline)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .padding(.horizontal, 10)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                    } else {
                        Button {
                            loadList(false)
                            loadList(true)
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                        .keyboardShortcut("r", modifiers: .command)
                        .padding(.horizontal, -10)
                        .contextMenu {
                            Button("Use Cache") {
                                loadList(true)
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Picker(selection: $currentPage) {
                        Label("All Posts", systemImage: "list.bullet")
                            .tag(CourseDisplayOption.allPosts)
                        Divider()
                        Label("Announcements", systemImage: "megaphone")
                            .tag(CourseDisplayOption.announcements)
                        Label("Courseworks", systemImage: "square.and.pencil")
                            .tag(CourseDisplayOption.courseWork)
                        Label("Materials", systemImage: "doc")
                            .tag(CourseDisplayOption.courseMaterial)
                        Label("Resources", systemImage: "link")
                            .tag(CourseDisplayOption.resources)
                        //                    Label("Register", systemImage: "person.2")
                        //                        .tag(CourseDisplayOption.userRegister)
                    } label: {
                        EmptyView()
                    }
                    .pickerStyle(.menu)
                    .padding(.horizontal, -10)
                }
            }
        }
        #endif
    }

    var postsContent: some View {
        GeometryReader { geometry in
            List {
                CoursePostListView(postData: courseMaterials.map({ .courseMaterial($0) })) { post in AnyView(
                    GroupBox {
                        VStack(alignment: .leading) {
                            switch post {
                            case .courseMaterial(let material):
                                    Text(material.title)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .lineLimit(2)
                                        .padding([.top, .horizontal], 5)
                                    
                                if let materials = material.materials, materials.count > 0 {
                                    let gridCount = Int(floor((geometry.size.width - 70) / 350)) < 1 ? 1 : Int(floor((geometry.size.width - 70) / 350))
                                    LazyVGrid(columns: .init(repeating: GridItem(.flexible(), spacing: 15),
                                                             count: gridCount), // set to (materials.count > 1) ? gridCount : 1 if you want link to stretch detailview's width
                                              spacing: 20) {
                                        ForEach(materials) { material in
                                            ZStack {
                                                if let driveFile = material.driveFile?.driveFile {
                                                    LinkPreview(title: driveFile.title ?? "", url: URL(string: driveFile.alternateLink)!, showAttachment: true)
                                                        .scaleEffect(geometry.size.width < 375 ? 0.78 : geometry.size.width < 400 ? 0.90 : 1)
                                                }
                                                
                                                if let youtubeVideo = material.youtubeVideo {
                                                    LinkPreview(url: URL(string: youtubeVideo.alternateLink)!, showAttachment: true)
                                                        .scaleEffect(geometry.size.width < 375 ? 0.78 : geometry.size.width < 400 ? 0.90 : 1)
                                                }
                                                
                                                if let link = material.form?.formUrl {
                                                    LinkPreview(url: URL(string: link)!, showAttachment: true)
                                                        .scaleEffect(geometry.size.width < 375 ? 0.78 : geometry.size.width < 400 ? 0.90 : 1)
                                                }
                                                
                                                if let materialLink = material.link {
                                                    LinkPreview(url: URL(string: materialLink.url)!, showAttachment: true)
                                                        .scaleEffect(geometry.size.width < 375 ? 0.78 : geometry.size.width < 400 ? 0.90 : 1)
                                                }
                                            }
                                            .padding(.all, geometry.size.width < 400 ? 0 : 5)
                                        }
                                    }
                                } else {
                                    Text("This post has no materials attached.")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.all, geometry.size.width < 400 ? 0 : 5)
                                }
                            default:
                                Text("Non material found")
                            }
                        }
                        .animation(.spring(dampingFraction: 0.8), value: geometry.size)
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
}
