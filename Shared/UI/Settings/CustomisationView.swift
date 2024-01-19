//
//  CustomisationView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 16/5/23.
//

import SwiftUI
import SymbolPicker
import GlassRoomInterface

struct CustomisationView: View {
    @ObservedObject var coursesManager: GlobalCoursesDataManager = .global
    @ObservedObject var configuration: CoursesConfiguration = .global

    @State var selectedIconReplacement: String?
    @State var showIconPopup: Bool = false

    var body: some View {
        VStack {
            #if os(macOS)
            HStack {
                coloursList
            }
            #else
            coloursList
            #endif
            
            #if os(macOS)
            HStack {
                Spacer()
                Button("Save") {
                    configuration.saveToFileSystem()
                    configuration.objectWillChange.send()
                }
                Button("Export") {
                    let path = FileSystem.path(file: .courseConfigurations)
                    NSWorkspace.shared.selectFile(
                        nil,
                        inFileViewerRootedAtPath: path.deletingLastPathComponent().relativePath
                    )
                }
                Button("Share Link") {
                    print(configuration.exportURL())
                }
            }
            .padding(.horizontal)
            #endif
        }
        #if os(macOS)
        .padding(15)
        #endif
    }
    
    var coloursList: some View {
        List {
            ForEach(coursesManager.courses, id: \.id) { course in
                HStack {
                    Text(course.name)
                    Spacer()
                    Circle()
                        .fill(configuration.colorFor(course.id))
                        .reverseMask {
                            Image(systemName: configuration.iconFor(course.id))
                                .resizable()
                                .scaledToFit()
                                .padding(3)
                        }
                        .frame(width: 24, height: 24)
                        .foregroundColor(.accentColor)
                        .disabled(true)
                }
                .tag(course)
                .onTapGesture {
                    selectedIconReplacement = course.id
                    showIconPopup = true
                }
            }
        }
        #if os(iOS)
        .navigationTitle("Colours & Symbols")
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .sheet(isPresented: $showIconPopup) {
            SymbolPicker(symbol: .init(get: {
                if let selectedIconReplacement {
                    return configuration.iconFor(selectedIconReplacement)
                } else {
                    return "person.2.fill"
                }
            }, set: { newValue in
                configuration.customIcons[selectedIconReplacement!] = newValue
            }))
            #if os(macOS)
            .safeAreaInset(edge: .bottom) {
                Rectangle().fill(.thinMaterial)
                    .overlay {
                        HStack {
                            Spacer()
                            ColorPicker("Color", selection: .init(get: {
                                if let selectedIconReplacement {
                                    return configuration.colorFor(selectedIconReplacement)
                                } else {
                                    return .accentColor
                                }
                            }, set: { newValue in
                                configuration.customColors[selectedIconReplacement!] = newValue
                            }))
                        }
                        .padding(.horizontal, 10)
                    }
                    .frame(height: 30)
                    .overlay(alignment: .top) {
                        Divider()
                    }
            }
            #else
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Spacer()
                    ColorPicker("Color", selection: .init(get: {
                        if let selectedIconReplacement {
                            return configuration.colorFor(selectedIconReplacement)
                        } else {
                            return .accentColor
                        }
                    }, set: { newValue in
                        configuration.customColors[selectedIconReplacement!] = newValue
                    }))
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .background(.ultraThinMaterial)
            }
            #endif
        }
    }
}

struct CustomisationView_Previews: PreviewProvider {
    static var previews: some View {
        CustomisationView()
    }
}
