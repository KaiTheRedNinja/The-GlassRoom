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
    
    @State var textContent = String()
    @State var copiedLink = false
    @Binding var selectedCourse: GeneralCourse?
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
                    
                    ShareLink(item: announcement.alternateLink) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .buttonStyle(.plain)
                    .padding(.leading, 5)
                    
                    Button {
                        copiedLink = true
                        let pasteboard = NSPasteboard.general
                        pasteboard.declareTypes([.string], owner: nil)
                        pasteboard.setString("\(announcement.alternateLink)", forType: .string)
                    } label: {
                        HStack {
                            Image(systemName: "link")
                            if copiedLink {
                                Text("Copied!")
                            }
                        }
                    }
                    .padding(.leading, 5)
                    .buttonStyle(.plain)
                }
                .padding(.top, 2)
                
                HStack {
                    Text(.init(textContent))
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
                                }

                                if let youtubeVideo = material.youtubeVideo {
                                    LinkPreview(url: URL(string: youtubeVideo.alternateLink)!)
                                }

                                if let form = material.form {
                                    if let link = form.formURL {
                                        LinkPreview(url: URL(string: link)!)
                                    }
                                }

                                if let materialLink = material.link {
                                    LinkPreview(url: URL(string: materialLink.url)!)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.all)
        }
        .onAppear {
            copiedLink = false
            textContent = makeLinksHyperLink(announcement.text)
        }
        .onChange(of: announcement) { _ in
            copiedLink = false
            textContent = makeLinksHyperLink(announcement.text)
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
                    
                    ShareLink(item: courseWork.alternateLink) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .buttonStyle(.plain)
                    .padding(.leading, 5)
                    
                    Button {
                        copiedLink = true
                        let pasteboard = NSPasteboard.general
                        pasteboard.declareTypes([.string], owner: nil)
                        pasteboard.setString("\(courseWork.alternateLink)", forType: .string)
                    } label: {
                        HStack {
                            Image(systemName: "link")
                            if copiedLink {
                                Text("Copied!")
                            }
                        }
                    }
                    .padding(.leading, 5)
                    .buttonStyle(.plain)
                }
                .padding(.top, 2)
                .padding(.bottom, 10)
                
                if let _ = courseWork.description {
                    Divider()
                        .padding(.bottom, 10)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text(.init(textContent))
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
//                                        if let link = driveFile.driveFile.alternateLink {
                                        LinkPreview(url: URL(string: driveFile.driveFile.alternateLink)!)
//                                        }
                                    }

                                    if let youtubeVideo = material.youtubeVideo {
//                                        if let link = youtubeVideo.alternateLink {
                                        LinkPreview(url: URL(string: youtubeVideo.alternateLink)!)
//                                        }
                                    }

                                    if let form = material.form {
                                        if let link = form.formURL {
                                            LinkPreview(url: URL(string: link)!)
                                        }
                                    }

                                    if let materialLink = material.link {
                                        LinkPreview(url: URL(string: materialLink.url)!)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.all)
        }
        .onAppear {
            copiedLink = false
            if let description = courseWork.description {
                textContent = makeLinksHyperLink(description)
            }
        }
        .onChange(of: courseWork) { _ in
            copiedLink = false
            if let description = courseWork.description {
                textContent = makeLinksHyperLink(description)
            }
        }
    }
    
    func makeLinksHyperLink(_ ogText: String) -> String {
        var input = ogText
        
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
        
        for match in matches {
            guard let range = Range(match.range, in: input) else { continue }
            let url = input[range]
            
            input = input.replacingOccurrences(of: url, with: "[\(url)](\(url))")
        }
        
        return input
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(selectedCourse: .constant(nil), selectedPost: .constant(nil))
    }
}
