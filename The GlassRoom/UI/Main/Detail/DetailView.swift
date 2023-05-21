//
//  DetailView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 13/5/23.
//


import SwiftUI
import GlassRoomTypes
import LinkPresentation

struct DetailView: View {
    
    @State var textContent = ""
    @State var copiedLink = false
    @Binding var selectedCourse: GeneralCourse?
    @Binding var selectedPost: CoursePost?

    @ObservedObject var configuration = GlobalCoursesDataManager.global.configuration

    @AppStorage("tintToCourseColor") var tintToCourseColor: Bool = true
    
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
        }
    }
}

protocol DetailViewPage: View {
    var textContent: Binding<String> { get set }
    var copiedLink: Binding<Bool> { get set }
}

extension DetailViewPage {
    func makeLinksHyperLink(_ ogText: String) -> String {
        // add bionic reading support
        // highlight the first half or 4 characters of a word, whichever is shorter
        var input = UserDefaults.standard.bool(forKey: "enableBionicReading") ? addBionicReadingSupport(to: ogText) : ogText

        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))

        for match in matches {
            guard let range = Range(match.range, in: input) else { continue }
            let url = input[range]

            input = input.replacingOccurrences(of: url, with: "[\(url)](\(url))")
        }

        return input
    }

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
        let gridCount = Int(floor((geometry.size.width - 70) / 350)) < 1 ? 1 : Int(floor((geometry.size.width - 70) / 350))
        LazyVGrid(columns: .init(repeating: GridItem(.flexible(), spacing: 15),
                                 count: gridCount), // set to (materials.count > 1) ? gridCount : 1 if you want link to stretch detailview's width
                  spacing: 20) {
            ForEach(materials, id: \.id) { material in
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
            }
        }
        .animation(.spring(dampingFraction: 0.8), value: geometry.size)
    }
    
    @ViewBuilder
    func viewForAttachment(materials: AssignmentSubmission) -> some View {
        if let materialAttachments = materials.attachments {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(materialAttachments, id: \.id) { attachment in
                        HStack {
                            if let driveFile = attachment.driveFile {
                                LinkPreview(url: URL(string: driveFile.alternateLink)!, isAttachment: true)
                            }
                            
                            if let youtubeVideo = attachment.youtubeVideo {
                                LinkPreview(url: URL(string: youtubeVideo.alternateLink)!, isAttachment: true)
                            }
                            
                            if let link = attachment.form?.formUrl {
                                LinkPreview(url: URL(string: link)!, isAttachment: true)
                            }
                            
                            if let materialLink = attachment.link {
                                LinkPreview(url: URL(string: materialLink.url)!, isAttachment: true)
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
