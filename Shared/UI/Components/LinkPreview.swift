//
//  LinkPreview.swift
//  The GlassRoom
//
//  Created by Tristan on 14/05/2023.
//

import SwiftUI
import LinkPresentation
import GlassRoomAPI
import GlassRoomTypes

#if os(macOS)
import AppKit
struct LinkPreview: NSViewRepresentable {
    typealias NSViewType = LPLinkView
    
    var url: URL
    var isAttachment: Bool

    init(url: URL, isAttachment: Bool) {
        self.url = url
        self.isAttachment = isAttachment
    }
    
    func makeNSView(context: NSViewRepresentableContext<LinkPreview>) -> LinkPreview.NSViewType {
        let linkView = LPLinkView(url: url)

        return linkView
    }
    func updateNSView(_ nsView: LinkPreview.NSViewType, context: NSViewRepresentableContext<LinkPreview>) {
        if let cachedData = MetaCache.shared.retrieve(urlString: url.absoluteString) {
            nsView.metadata = cachedData
        } else {
            let provider = LPMetadataProvider()
            
            provider.startFetchingMetadata(for: url) { metadata, error in
                guard let metadata = metadata, error == nil else {
                    return
                }

                // if the title already is loaded, use that instead
                if let existingTitle = nsView.metadata.title {
                    metadata.title = existingTitle
                }
                
                if isAttachment {
                    metadata.imageProvider = nil
                }

                MetaCache.shared.cache(metadata: metadata)

                DispatchQueue.main.async {
                    nsView.metadata = metadata
                }
            }
        }
    }
}
#else
import SwiftUI
import LinkPresentation

struct LinkPreview: UIViewRepresentable {
    typealias UIViewType = LPLinkView
    var url: URL
    var isAttachment: Bool
    
    init(url: URL, isAttachment: Bool) {
        self.url = url
        self.isAttachment = isAttachment
    }
    
    func makeUIView(context: UIViewRepresentableContext<LinkPreview>) -> LinkPreview.UIViewType {
        let linkView = LPLinkView(url: url)
        
        return linkView
    }
    
    func updateUIView(_ uiView: LinkPreview.UIViewType, context: UIViewRepresentableContext<LinkPreview>) {
        if let cachedData = MetaCache.shared.retrieve(urlString: url.absoluteString) {
            uiView.metadata = cachedData
        } else {
            let provider = LPMetadataProvider()
            
            provider.startFetchingMetadata(for: url) { metadata, error in
                guard let metadata = metadata, error == nil else {
                    return
                }
                
                // if the title is already loaded, use that instead
                if let existingTitle = uiView.metadata.title {
                    metadata.title = existingTitle
                }
                
                if isAttachment {
                    metadata.imageProvider = nil
                }
                
                MetaCache.shared.cache(metadata: metadata)
                
                DispatchQueue.main.async {
                    uiView.metadata = metadata
                }
            }
        }
    }
}
#endif

// NOTE: This causes size issues
class MetaCache {
    private init() {}
    static var shared: MetaCache = .init()

    private var cache: [String: LPLinkMetadata] = [:]

    func cache(metadata: LPLinkMetadata) {
        cache[metadata.url!.absoluteString] = metadata
    }

    func retrieve(urlString: String) -> LPLinkMetadata? {
        return cache[urlString]
    }
}

extension String {
    func findMatches(pattern: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let nsStr = self as NSString
            let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: nsStr.length))

            return matches.map {
                nsStr.substring(with: $0.range)
            }
        } catch {
            Log.error("Error creating regular expression: \(error)")
            return []
        }
    }
}
