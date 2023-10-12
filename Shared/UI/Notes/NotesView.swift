//
//  NotesView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 5/6/23.
//

import SwiftUI
import GlassRoomTypes
import GlassRoomInterface

class GlobalNotesDataManager: ObservableObject, Codable {
    @Published private(set) var notes: [CoursePost.MinimalRepresentation: String]

    private var noteRevision: Int = 0
    func updateNote(_ representation: CoursePost.MinimalRepresentation, with string: String?) {
        if let string {
            notes[representation] = string
        } else {
            notes.removeValue(forKey: representation)
        }

        // make sure we don't save too often. This should save about every 2 seconds at the max.
        noteRevision += 1
        let savedNoteRevision = noteRevision
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if self.noteRevision == savedNoteRevision {
                print("Saving!")
                self.saveToFileSystem()
            }
        }
    }

    private init(notes: [CoursePost.MinimalRepresentation: String]) {
        self.notes = notes
    }

    // MARK: File system instance
    private static var fileSystemInstance: GlobalNotesDataManager?
    static func loadedFromFileSystem() -> GlobalNotesDataManager {
        if let fileSystemInstance {
            return fileSystemInstance
        }

        // if the file exists in CourseCache
        if FileSystem.exists(file: .notes),
           let savedConfig = FileSystem.read(GlobalNotesDataManager.self, from: .notes) {
            fileSystemInstance = savedConfig
            return savedConfig
        }
        let newInstance = GlobalNotesDataManager(notes: [:])
        fileSystemInstance = newInstance
        return newInstance
    }

    func saveToFileSystem() {
        FileSystem.write(self, to: .notes) { error in
            Log.error("Error writing: \(error.localizedDescription)")
        }
    }

    enum Keys: CodingKey {
        case notes
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(notes, forKey: .notes)
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.notes = try container.decode([CoursePost.MinimalRepresentation: String].self, forKey: .notes)
    }
}

struct NotesView: View {
//    @ObservedObject var notesManager: GlobalNotesDataManager = .global

    var body: some View {
        VStack {
            HStack {
                Text("Not Implemented Yet")
//                ForEach(notesManager.openNotes, id: \.id) { note in
//                    Text("Note: \(note.id)")
//                }
            }
        }
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView()
    }
}
