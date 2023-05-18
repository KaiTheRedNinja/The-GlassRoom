//
//  DebugLogsView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 18/5/23.
//

import SwiftUI
import GlassRoomTypes

struct DebugLogsView: View {
    @ObservedObject var logs: Log = .global

    @State var selectedId: UUID?

    var body: some View {
        List(selection: $selectedId) {
            ForEach(logs.logHistory) { history in
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(history.file): \(history.line)")
                    }
                    .font(.caption)
                    .bold()
                    Text("\(history.content)")
                        .lineLimit(selectedId == history.id ? nil : 3)
                    Divider()
                }
                .tag(history.id)
            }
        }
    }
}

struct DebugLogsView_Previews: PreviewProvider {
    static var previews: some View {
        DebugLogsView()
    }
}
