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
    
    @State var textContent = ""
    @State var copiedLink = false
    @Binding var selectedCourse: GeneralCourse?
    @Binding var selectedPost: CoursePost?
    
    var body: some View {
        if let selectedPost {
            switch selectedPost {
            case .announcement(let courseAnnouncement):
                AnnouncementDetailView(textContent: $textContent, copiedLink: $copiedLink, announcement: courseAnnouncement)
            case .courseWork(let courseWork):
                CourseWorkDetailView(textContent: $textContent, copiedLink: $copiedLink, courseWork: courseWork)
            case .courseMaterial(let courseWorkMaterial):
                CourseMaterialDetailView(textContent: $textContent, copiedLink: $copiedLink, courseWorkMaterial: courseWorkMaterial)
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
}

protocol DetailViewPage: View {
    var textContent: Binding<String> { get set }
    var copiedLink: Binding<Bool> { get set }
}

extension DetailViewPage {
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
                copiedLink.wrappedValue = true
                let pasteboard = NSPasteboard.general
                pasteboard.declareTypes([.string], owner: nil)
                pasteboard.setString("\(link)", forType: .string)
            } label: {
                HStack {
                    Image(systemName: "link")
                    if copiedLink.wrappedValue {
                        Text("Copied!")
                    }
                }
            }
            .padding(.leading, 5)
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    func viewForMaterial(materials: [AssignmentMaterial], geometry: GeometryProxy) -> some View {
        let gridCount = Int(floor((geometry.size.width - 70) / 200))
        LazyVGrid(columns: .init(repeating: GridItem(.flexible(), spacing: 15),
                                 count: (materials.count > 1) ? gridCount : 0),
                  spacing: 20) {
            ForEach(materials, id: \.id) { material in
                ZStack {
                    if let driveFile = material.driveFile?.driveFile {
                        LinkPreview(url: URL(string: driveFile.alternateLink)!)
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

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(selectedCourse: .constant(nil), selectedPost: .constant(nil))
    }
}
