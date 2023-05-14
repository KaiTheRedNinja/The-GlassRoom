//
//  DetailView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 13/5/23.
//


import SwiftUI
import GlassRoomAPI
import LinkPresentation

struct DetailView: View {
    @Binding var selectedCourse: Course?
    @Binding var selectedPost: CoursePost?
    
    var body: some View {
        if let selectedPost {
            switch selectedPost {
            case .announcement(let courseAnnouncement):
                announcementView(for: courseAnnouncement)
            case .courseWork(let courseWork):
                courseWorkView(for: courseWork)
            }
        } else {
            VStack {
                //                Text("Course: \(selectedCourse?.name ?? "nothing")")
                Text("No Post Selected")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.1)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .padding(.horizontal)
            }
        }
    }

    func announcementView(for announcement: CourseAnnouncement) -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Link(destination: URL(string: announcement.alternateLink)!) {
                        Label("Open in browser", systemImage: "safari")
                    }
                }
                .padding(.top, 2)
                
                HStack {
                    Text(announcement.text)
                    Spacer()
                }

                Spacer()

                if announcement.materials != nil {
                    Divider()

                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(announcement.materials ?? [], id: \.id) { material in
                                if let driveFile = material.driveFile {
                                    LinkPreview(url: URL(string: driveFile.driveFile.alternateLink)!)
//                                            .frame(height: 100)
//                                            .scaledToFit()
                                }

                                if let youtubeVideo = material.youtubeVideo {
                                    LinkPreview(url: URL(string: youtubeVideo.alternateLink)!)
//                                            .frame(height: 100)
//                                            .scaledToFit()
                                }

                                if let form = material.form {
                                    LinkPreview(url: URL(string: form.formURL)!)
//                                            .frame(height: 100)
//                                            .scaledToFit()
                                }

                                if let materialLink = material.link {
                                    LinkPreview(url: URL(string: materialLink.url)!)
//                                            .frame(height: 100)
//                                            .scaledToFit()
                                }
                            }
                        }
                    }
                }
            }
            .padding(.all)
        }
    }

    func courseWorkView(for courseWork: CourseWork) -> some View {
        ScrollView {
            VStack {
                HStack {
                    Text(courseWork.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Link(destination: URL(string: courseWork.alternateLink)!) {
                        Label("Open in browser", systemImage: "safari")
                    }
                }
                .padding(.top, 2)
                .padding(.bottom, 10)
                
                if let description = courseWork.description {
                    Divider()
                        .padding(.bottom, 10)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text(description)
                            Spacer()
                        }
                    }
                }
                
                Spacer()
                
                VStack {
                    if courseWork.materials != nil {
                        Divider()

                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(courseWork.materials ?? [], id: \.id) { material in
                                    if let driveFile = material.driveFile {
                                        LinkPreview(url: URL(string: driveFile.driveFile.alternateLink)!)
    //                                            .frame(height: 100)
    //                                            .scaledToFit()
                                    }

                                    if let youtubeVideo = material.youtubeVideo {
                                        LinkPreview(url: URL(string: youtubeVideo.alternateLink)!)
    //                                            .frame(height: 100)
    //                                            .scaledToFit()
                                    }

                                    if let form = material.form {
                                        LinkPreview(url: URL(string: form.formURL)!)
    //                                            .frame(height: 100)
    //                                            .scaledToFit()
                                    }

                                    if let materialLink = material.link {
                                        LinkPreview(url: URL(string: materialLink.url)!)
    //                                            .frame(height: 100)
    //                                            .scaledToFit()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.all)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(selectedCourse: .constant(nil), selectedPost: .constant(nil))
    }
}
