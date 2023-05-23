//
//  LinkPreview.swift
//  The GlassRoom
//
//  Created by Tristan on 14/05/2023.
//

import AppKit
import SwiftUI
import LinkPresentation
import GlassRoomAPI
import GlassRoomTypes

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

        // if its a docs, detect the id
        if url.absoluteString.contains("/docs.google.com/") || url.absoluteString.contains("/drive.google.com/") {
            // detect the file id
            let fileIds = url.absoluteString.findMatches(pattern: "/d/[a-zA-Z0-9-_]+/")
            if let fileIdRaw = fileIds.first {
                let fileId = String(fileIdRaw.dropFirst(3).dropLast(1))

                GlassRoomAPI.GDDriveDetails.get(
                    params: .init(fileId: fileId),
                    query: .init(fields: ["name"]),
                    data: .init()
                ) { result in
                    switch result {
                    case .success(let success):
                        let metadata = LPLinkMetadata()
                        metadata.originalURL = url
                        metadata.url = metadata.originalURL
                        metadata.title = success.name
                        linkView.metadata = metadata
                    case .failure(let failure):
                        Log.error("Failure: \(failure.localizedDescription)")
                    }
                }
            }
        }

        return linkView
    }

    func driveIdFor(urlString: String) -> String? {
        guard urlString.contains("/docs.google.com/") || urlString.contains("/drive.google.com/")
        else { return nil }
        // detect the file id
        let fileIds = url.absoluteString.findMatches(pattern: "/d/[a-zA-Z0-9-_]+/")
        if let fileIdRaw = fileIds.first {
            let fileId = String(fileIdRaw.dropFirst(3).dropLast(1))
            return fileId
        }
        return nil
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
