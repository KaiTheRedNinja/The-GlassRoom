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
        Table(apiCalls.apiHistory) {
            TableColumn("Request Type", value: \.requestType)
            TableColumn("Return Type", value: \.expectedResponseType)
            TableColumn("URL", value: \.requestUrl)
            TableColumn("Parameters", value: \.parametersString)
        }
    }
}

extension APILogger.APICall {
    var parametersString: String {
        parameters
            .map({ $0.key + ": " + $0.value })
            .joined(separator: "  |  ")
    }
}

struct DebugAPICallsView_Previews: PreviewProvider {
    static var previews: some View {
        DebugAPICallsView()
    }
}
