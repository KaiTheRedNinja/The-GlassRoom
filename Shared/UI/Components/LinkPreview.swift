//
//  LinkPreview.swift
//  The GlassRoom
//
//  Created by Tristan Chay on 18/1/24.
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
    var showAttachment: Bool
    var title: String
    
    init(title: String = "", url: URL, showAttachment: Bool) {
        self.url = url
        self.showAttachment = showAttachment
        self.title = title
    }
    
    func makeNSView(context: NSViewRepresentableContext<LinkPreview>) -> LinkPreview.NSViewType {
        let linkView = LPLinkView(url: url)

        let metadata = LPLinkMetadata()
        if !title.isEmpty {
            metadata.title = title
        }
        metadata.originalURL = url
        metadata.url = metadata.originalURL
        linkView.metadata = metadata

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
                
                if !showAttachment {
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
    var showAttachment: Bool
    var title: String
    
    init(title: String = "", url: URL, showAttachment: Bool) {
        self.url = url
        self.showAttachment = showAttachment
        self.title = title
    }
    
    func makeUIView(context: UIViewRepresentableContext<LinkPreview>) -> LinkPreview.UIViewType {
        let linkView = LPLinkView(url: url)
        
        let metadata = LPLinkMetadata()
        if !title.isEmpty {
            metadata.title = title
        }
        metadata.originalURL = url
        metadata.url = metadata.originalURL
        linkView.metadata = metadata
        
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
                
                if !showAttachment {
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
