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

                OpenNotesButton(post: post)
            }
            #endif

            PostNoteView(post: post, dividerAbove: dividerAbove)
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
                        LinkView(driveFile: driveFile)
                    }

                    if let youtubeVideo = material.youtubeVideo {
                        LinkView(url: URL(string: youtubeVideo.alternateLink)!)
                    }

                    if let link = material.form?.formUrl {
                        LinkView(url: URL(string: link)!)
                    }

                    if let materialLink = material.link {
                        LinkView(url: URL(string: materialLink.url)!)
                    }
                }
            }
        }
        .animation(.spring(dampingFraction: 0.8), value: size)
    }
    
    @ViewBuilder
    func viewForAttachment(materials: AssignmentSubmission) -> some View {
        if let materialAttachments = materials.attachments {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(materialAttachments, id: \.id) { attachment in
                        HStack {
                            if let driveFile = attachment.driveFile {
                                LinkView(driveFile: driveFile)
                            }

                            if let youtubeVideo = attachment.youtubeVideo {
                                LinkView(url: URL(string: youtubeVideo.alternateLink)!)
                            }

                            if let link = attachment.form?.formUrl {
                                LinkView(url: URL(string: link)!)
                            }

                            if let materialLink = attachment.link {
                                LinkView(url: URL(string: materialLink.url)!)
                            }
                        }
                    }
                }
            }
            .cornerRadius(8)
        }
    }
}

struct OpenNotesButton: View {
    var post: CoursePost

    @ObservedObject var manager = GlobalNotesDataManager.loadedFromFileSystem()

    var body: some View {
        Button(role: manager.notes.keys.contains(post.minimalRepresentation) ? .destructive : .none) {
            // create the note if it exists, delete it if not.
            if manager.notes.keys.contains(post.minimalRepresentation) {
                manager.updateNote(post.minimalRepresentation, with: nil)
            } else {
                manager.updateNote(post.minimalRepresentation, with: "Empty Note")
            }
        } label: {
            #if os(macOS)
            ZStack(alignment: .bottomTrailing) {
                Image(systemName: manager.notes.keys.contains(post.minimalRepresentation) ? "note.text" : "note.text.badge.plus")
                if manager.notes.keys.contains(post.minimalRepresentation) {
                    Image(systemName: "trash.circle.fill")
                        .resizable()
                        .background {
                            Circle()
                                .fill(.thickMaterial)
                        }
                        .scaledToFit()
                        .frame(width: 10, height: 10)
                        .offset(y: 2)
                }
            }
            #else
            Label("\(manager.notes.keys.contains(post.minimalRepresentation) ? "Remove" : "Add") Note", systemImage: manager.notes.keys.contains(post.minimalRepresentation) ? "trash" : "note.text.badge.plus")
            #endif
        }
        .buttonStyle(.plain)
    }
}

struct PostNoteView: View {
    @ObservedObject var notesManager: GlobalNotesDataManager = .loadedFromFileSystem()

    var post: CoursePost

    @State var dividerAbove: Bool
    @State var textContents: String = ""

    var body: some View {
        if let noteContents = notesManager.notes[post.minimalRepresentation] {
            VStack {
                #if os(macOS)
                Divider()
                    .padding(.vertical, 10)
                #else
                if dividerAbove {
                    Divider()
                        .padding(.vertical, 10)
                }
                #endif
                TextEditor(text: $textContents)
                #if os(macOS)
                    .padding(-5)
                #endif
                    .onChange(of: textContents) { _ in
                        notesManager.updateNote(post.minimalRepresentation, with: textContents)
                    }
                    .scrollIndicators(.never)
                #if os(iOS)
                if !dividerAbove {
                    Divider()
                        .padding(.vertical, 5)
                }
                #endif
            }
            .onAppear {
                textContents = noteContents
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(selectedCourse: .constant(nil), selectedPost: .constant(nil))
    }
}
