//
//  DetailView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 13/5/23.
//

import SwiftUI
import GlassRoomTypes
import GlassRoomInterface
import LinkPresentation

struct DetailView: View {
    
    @State var textContent = ""
    @State var copiedLink = false
    @Binding var selectedCourse: GeneralCourse?
    @Binding var selectedPost: CoursePost?

    @ObservedObject var configuration: CoursesConfiguration = .global

    @AppStorage("tintToCourseColor") var tintToCourseColor: Bool = false
    
    var body: some View {
        if let selectedPost {
            ZStack {
                if tintToCourseColor {
                    configuration.colorFor(selectedPost.courseId)
                        .opacity(0.1)
                }
                switch selectedPost {
                case .announcement(let courseAnnouncement):
                    AnnouncementDetailView(textContent: $textContent, copiedLink: $copiedLink, announcement: courseAnnouncement)
                        .scrollContentBackground(.hidden)
                case .courseWork(let courseWork):
                    CourseWorkDetailView(textContent: $textContent, copiedLink: $copiedLink, courseWork: courseWork)
                        .scrollContentBackground(.hidden)
                case .courseMaterial(let courseWorkMaterial):
                    CourseMaterialDetailView(textContent: $textContent, copiedLink: $copiedLink, courseWorkMaterial: courseWorkMaterial)
                        .scrollContentBackground(.hidden)
                }
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

protocol DetailViewPage: View {
    var textContent: Binding<String> { get set }
    var copiedLink: Binding<Bool> { get set }
}

extension DetailViewPage {
    func addBionicReadingSupport(to input: String) -> String {
        let lines = input.components(separatedBy: .newlines)
        var result = ""

        for line in lines {
            let words = line.components(separatedBy: .whitespaces)

            for word in words {
                if word.rangeOfCharacter(from: .decimalDigits) != nil {
                    // Skip words that contain a number
                    result += word + " "
                    continue
                }

                let halfLength = min(word.count / 2, 4)
                guard halfLength > 0 else { continue }
                let startIndex = word.startIndex
                let endIndex = word.index(startIndex, offsetBy: halfLength)

                let boldedWord = "**" + word[startIndex..<endIndex] + "**" + word[endIndex...]
                result += boldedWord + " "
            }

            result += "\n"
        }

        return result.trimmingCharacters(in: .newlines)
    }

    func viewForButtons(link: String, post: CoursePost, dividerAbove: Bool) -> some View {
        VStack(alignment: .leading) {
            #if os(macOS)
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
                    #if os(macOS)
                    let pasteboard = NSPasteboard.general
                    pasteboard.declareTypes([.string], owner: nil)
                    pasteboard.setString("\(link)", forType: .string)
                    #else
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = link
                    #endif
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
            #endif
        }
    }

    @ViewBuilder
    func viewForMaterial(materials: [AssignmentMaterial], size: CGSize) -> some View {
        let gridCount = Int(floor((size.width - 70) / 350)) < 1 ? 1 : Int(floor((size.width - 70) / 350))
        LazyVGrid(columns: .init(repeating: GridItem(.flexible(), spacing: 15),
                                 count: gridCount), // set to (materials.count > 1) ? gridCount : 1 if you want link to stretch detailview's width
                  spacing: 20) {
            ForEach(materials, id: \.id) { material in
                ZStack {
                    if let driveFile = material.driveFile?.driveFile {
                        LinkPreview(title: driveFile.title ?? "", url: URL(string: driveFile.alternateLink)!, showAttachment: true)
                    }

                    if let youtubeVideo = material.youtubeVideo {
                        LinkPreview(url: URL(string: youtubeVideo.alternateLink)!, showAttachment: true)
                    }

                    if let link = material.form?.formUrl {
                        LinkPreview(url: URL(string: link)!, showAttachment: true)
                    }

                    if let materialLink = material.link {
                        LinkPreview(url: URL(string: materialLink.url)!, showAttachment: true)
                    }
                }
            }
        }
        .animation(.spring(dampingFraction: 0.8), value: size)
    }
    
    @ViewBuilder
    func viewForAttachment(materials: AssignmentSubmission) -> some View {
        if let materialAttachments = materials.attachments {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(materialAttachments, id: \.id) { attachment in
                        HStack {
                            if let driveFile = attachment.driveFile {
                                LinkPreview(title: driveFile.title ?? "", url: URL(string: driveFile.alternateLink)!, showAttachment: false)
                            }

                            if let youtubeVideo = attachment.youtubeVideo {
                                LinkPreview(url: URL(string: youtubeVideo.alternateLink)!, showAttachment: false)
                            }

                            if let link = attachment.form?.formUrl {
                                LinkPreview(url: URL(string: link)!, showAttachment: false)
                            }

                            if let materialLink = attachment.link {
                                LinkPreview(url: URL(string: materialLink.url)!, showAttachment: false)
                            }
                        }
                    }
                }
            }
            .cornerRadius(8)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(selectedCourse: .constant(nil), selectedPost: .constant(nil))
    }
}
