//
//  DebugAPICallsView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 18/5/23.
//

import SwiftUI
import GlassRoomTypes

struct DebugAPICallsView: View {
    @ObservedObject var apiCalls: APILogger = .global

    @State var selectedId: UUID?

    var body: some View {
        List(selection: $selectedId) {
            ForEach(apiCalls.apiHistory) { history in
                VStack(alignment: .leading) {
                    HStack {
                        Text(history.requestType)
                        Image(systemName: "arrow.right")
                        Text(history.expectedResponseType)
                    }
                    .font(.caption)
                    .bold()
                    Text(history.requestUrl)
                        .lineLimit(selectedId == history.id ? nil : 3)
                    GroupBox {
                        ScrollView(.horizontal, showsIndicators: false) {
                            VStack(alignment: .leading) {
                                ForEach(Array(history.parameters), id: \.key) { param in
                                    HStack {
                                        Text(param.key)
                                            .lineLimit(1)
                                            .frame(width: 150)
                                            .multilineTextAlignment(.leading)
                                        Text(param.value)
                                            .lineLimit(1)
                                    }
                                }
                            }
                        }
                    }
                    Divider()
                }
                .tag(history.id)
            }
        }
        .frame(width: 400, height: 300)
    }
}

struct DebugAPICallsView_Previews: PreviewProvider {
    static var previews: some View {
        DebugAPICallsView()
    }
}
