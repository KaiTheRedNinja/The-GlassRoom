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

struct LinkPreview: NSViewRepresentable {
    typealias NSViewType = LPLinkView
    
    var url: URL

    init(url: URL) {
        self.url = url
    }
    
    func makeNSView(context: NSViewRepresentableContext<LinkPreview>) -> LinkPreview.NSViewType {
        print("URL: \(url)")

        let linkView = LPLinkView(url: url)

        // if its a docs, detect the id
        if url.absoluteString.contains("/docs.google.com/") || url.absoluteString.contains("/drive.google.com/") {
            print("Its a drive link")
            // detect the file id
            let fileIds = url.absoluteString.findMatches(pattern: "/d/[a-zA-Z0-9-_]+/")
            if let fileIdRaw = fileIds.first {
                let fileId = String(fileIdRaw.dropFirst(3).dropLast(1))
                print("File id: \(fileId)")

                GlassRoomAPI.GDDriveDetails.get(
                    params: .init(fileId: fileId),
                    query: .init(fields: ["name"]),
                    data: .init()
                ) { result in
                    switch result {
                    case .success(let success):
                        print("Success: \(success.name ?? "no name")")
                        print("Metadata 1: \(linkView.metadata.description)")
                        let metadata = LPLinkMetadata()
                        metadata.originalURL = url
                        metadata.url = metadata.originalURL
                        metadata.title = success.name
//                        metadata.imageProvider = NSItemProvider.init(contentsOf:
//                                                                        Bundle.main.url(forResource: "apple-pie", withExtension: "jpg"))
                        linkView.metadata = metadata
                    case .failure(let failure):
                        print("Failure: \(failure.localizedDescription)")
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
        if let cachedData = MetaCache.retrieve(urlString: url.absoluteString) {
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

                MetaCache.cache(metadata: metadata)
                
                DispatchQueue.main.async {
                    nsView.metadata = metadata
                }
            }
        }
    }
}

struct MetaCache {
    static func cache(metadata: LPLinkMetadata) {

        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: metadata, requiringSecureCoding: true)
            UserDefaults.standard.setValue(data, forKey: metadata.url!.absoluteString)
        }
        catch let error {
            print("Error when cachine: \(error.localizedDescription)")
        }
    }

    static func retrieve(urlString: String) -> LPLinkMetadata? {
        do {
            guard let data = UserDefaults.standard.object(forKey: urlString) as? Data,
                  let metadata = try NSKeyedUnarchiver.unarchivedObject(ofClass: LPLinkMetadata.self, from: data) else { return nil }
            return metadata
        }

        catch let error {
            print("Error when cachine: \(error.localizedDescription)")
            return nil
        }
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
            print("Error creating regular expression: \(error)")
            return []
        }
    }
}
