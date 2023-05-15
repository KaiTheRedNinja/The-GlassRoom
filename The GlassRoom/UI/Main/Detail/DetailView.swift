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
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        
                        Spacer()
                        
                        viewForButtons(announcement.alternateLink)
                    }
                    .padding(.top, 2)
                    
                    HStack {
                        Text(.init(textContent))
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
            copiedLink = false
            textContent = makeLinksHyperLink(announcement.text)
        }
        .onChange(of: announcement) { _ in
            copiedLink = false
            textContent = makeLinksHyperLink(announcement.text)
        }
    }

    func courseWorkView(for courseWork: CourseWork) -> some View {
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
                                Text(.init(textContent))
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
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    HStack {
                        Text(courseWorkMaterial.title)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        viewForButtons(courseWorkMaterial.alternateLink)
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
                            
                            viewForMaterial(materials: material, geometry: geometry)
                        }
                    }
                }
                .padding(.all)
            }
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
    
    func viewForButtons(_ link: String) -> some View {
        HStack {
            Link(destination: URL(string: link)!) {
                Image(systemName: "safari")
                    .foregroundColor(.secondary)
            }
            
            ShareLink(item: link) {
                Image(systemName: "square.and.arrow.up")
            }
            .buttonStyle(.plain)
            .padding(.leading, 5)
            
            Button {
                copiedLink = true
                let pasteboard = NSPasteboard.general
                pasteboard.declareTypes([.string], owner: nil)
                pasteboard.setString("\(link)", forType: .string)
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
    }
    
    func viewForMaterial(materials: [AssignmentMaterial], geometry: GeometryProxy) -> some View {
        VStack {
            if materials.count > 1 {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: Int(floor((geometry.size.width - 70) / 200))), spacing: 20) {
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
                .padding(.horizontal)
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 1), spacing: 20) {
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
                .padding(.horizontal)
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(selectedCourse: .constant(nil), selectedPost: .constant(nil))
    }
}
