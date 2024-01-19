//
//  RenameCourseGroupView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 19/5/23.
//

import SwiftUI
import GlassRoomInterface

struct RenameCourseGroupView: View {
    @ObservedObject var configuration: CoursesConfiguration = .global
    @Environment(\.presentationMode) var presentationMode

    var groupString: String

    var body: some View {
        #if os(macOS)
        VStack {
            if let groupIndex = configuration.courseGroups.firstIndex(where: { $0.id == groupString }) {
                TextField("Name", text: .init(get: {
                    configuration.courseGroups[groupIndex].groupName
                }, set: { newValue in
                    configuration.courseGroups[groupIndex].groupName = newValue
                }))
                HStack {
                    Spacer()
                    Button("Save") {
                        configuration.saveToFileSystem()
                        configuration.objectWillChange.send()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                Text("No Group Found")
            }
        }
        .padding(15)
        .frame(width: 200, height: 170)
        #else
        if let groupIndex = configuration.courseGroups.firstIndex(where: { $0.id == groupString }) {
            TextField("Name", text: .init(get: {
                configuration.courseGroups[groupIndex].groupName
            }, set: { newValue in
                configuration.courseGroups[groupIndex].groupName = newValue
            }))
            Button("Save") {
                configuration.saveToFileSystem()
                configuration.objectWillChange.send()
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(.borderedProminent)
        } else {
            Text("No Group Found")
        }
        #endif
    }
}
