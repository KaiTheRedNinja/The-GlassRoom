//
//  NotesView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 5/6/23.
//

import SwiftUI

class GlobalNotesDataManager: ObservableObject {
    static let global: GlobalNotesDataManager = .init()
    private init() {
        openNotes = []
    }

    @Published private(set) var openNotes: [CoursePost]

    func openNote(for post: CoursePost) {
        guard !openNotes.contains(where: { $0.id == post.id }) else { return }
        openNotes.append(post)
    }
}

struct NotesView: View {
    @ObservedObject var notesManager: GlobalNotesDataManager = .global

    var body: some View {
        VStack {
            HStack {
                ForEach(notesManager.openNotes, id: \.courseId) { note in
                    Text("Note: \(note.id)")
                }
            }
        }
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView()
    }
}
