//
//  ConfigurationPreviewView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 1/8/23.
//

import SwiftUI
import GlassRoomInterface

fileprivate typealias ConfigKeys = CoursesConfiguration.Keys
fileprivate typealias ConfigLoadStyle = CoursesConfiguration.LoadStyle

struct ConfigurationPreviewView: View {
    @Binding var configuration: CoursesConfiguration?

    init(configuration: Binding<CoursesConfiguration?>) {
        self._configuration = configuration
        self.fields = [:]
    }

    @State private var fields: [ConfigKeys: ConfigLoadStyle]

    var body: some View {
        List {
            Section {
                ForEach(ConfigKeys.allCases, id: \.self) { key in
                    HStack {
                        Text(key.description)
                        Color.clear.frame(height: 10)
                        Picker("", selection: .init(get: { () -> String in
                            if let style = fields[key] {
                                return style.description
                            }
                            return "Excluded"
                        }, set: { newValue in
                            if newValue == "Excluded" {
                                fields.removeValue(forKey: key)
                            }
                            if let style = ConfigLoadStyle.allCases.first(where: { $0.description == newValue }) {
                                fields[key] = style
                            }
                        })) {
                            Text("Excluded")
                                .tag("Excluded")
                            ForEach(ConfigLoadStyle.allCases, id: \.self) { style in
                                Text(style.description)
                                    .tag(style.description)
                            }
                        }
                        .menuStyle(ButtonMenuStyle())
                    }
                }
            }

            Section {
                Button("Load") {
                    guard let configuration else { return }
                    CoursesConfiguration.global.loadIntoSelf(config: configuration, fields: fields)
                }
                Button("Cancel") {
                    configuration = nil
                }
            }
        }
    }
}
