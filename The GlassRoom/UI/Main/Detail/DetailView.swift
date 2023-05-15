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
            case .courseMaterial(let courseWorkMaterial):
                courseMaterialView(for: courseWorkMaterial)
            }
        } else {
            VStack {
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
                        Image(systemName: "safari")
                            .foregroundColor(.accentColor)
                    }
                    
                    ShareLink(item: announcement.alternateLink) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.accentColor)
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
                        .foregroundColor(.accentColor)
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

                if let material = announcement.materials {
                    Divider()

                    viewForMaterial(materials: material)
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
                        Image(systemName: "safari")
                            .foregroundColor(.secondary)
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
                    if let material = courseWork.materials {
                        Divider()

                        viewForMaterial(materials: material)
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
    
    func courseMaterialView(for courseWorkMaterial: CourseWorkMaterial) -> some View {
        ScrollView {
            VStack {
                HStack {
                    Text(courseWorkMaterial.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Link(destination: URL(string: courseWorkMaterial.alternateLink)!) {
                        Image(systemName: "safari")
                            .foregroundColor(.secondary)
                    }
                    
                    ShareLink(item: courseWorkMaterial.alternateLink) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .buttonStyle(.plain)
                    .padding(.leading, 5)
                    
                    Button {
                        copiedLink = true
                        let pasteboard = NSPasteboard.general
                        pasteboard.declareTypes([.string], owner: nil)
                        pasteboard.setString("\(courseWorkMaterial.alternateLink)", forType: .string)
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
                
                if let _ = courseWorkMaterial.description {
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
                    if let material = courseWorkMaterial.materials {
                        Divider()

                        viewForMaterial(materials: material)
                    }
                }
            }
            .padding(.all)
        }
        .onAppear {
            copiedLink = false
            if let description = courseWorkMaterial.description {
                textContent = makeLinksHyperLink(description)
            }
        }
        .onChange(of: courseWorkMaterial) { _ in
            copiedLink = false
            if let description = courseWorkMaterial.description {
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

    func viewForMaterial(materials: [AssignmentMaterial]) -> some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(materials, id: \.id) { material in
                    ZStack {
                        if let driveFile = material.driveFile {
                            LinkPreview(url: URL(string: driveFile.driveFile.alternateLink)!)
                        }

                        if let youtubeVideo = material.youtubeVideo {
                            LinkPreview(url: URL(string: youtubeVideo.alternateLink)!)
                        }

                        if let link = material.form?.formUrl {
                            LinkPreview(url: URL(string: link)!)
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

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(selectedCourse: .constant(nil), selectedPost: .constant(nil))
    }
}
