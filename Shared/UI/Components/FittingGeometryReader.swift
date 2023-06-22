//
//  FittingGeometryReader.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 3/6/23.
//

import SwiftUI

struct FittingGeometryReader<Content: View>: View {
    var spaceName: String?
    var content: (GeometryProxy?) -> Content
    @State private var proxy: GeometryProxy?

    var body: some View {
        content(proxy)
            .background {
                GeometryReader { proxy in
                    Color.white.opacity(0.001)
                        .onAppear {
                            self.proxy = proxy
                        }
                        .onChange(of: proxy.size) { _ in
                            self.proxy = proxy
                        }
                    if let spaceName {
                        Color.white.opacity(0.001)
                            .onChange(of: proxy.frame(in: .named(spaceName))) { _ in
                                self.proxy = proxy
                            }
                    }
                }
            }
    }
}
