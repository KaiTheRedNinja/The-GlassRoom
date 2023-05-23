//
//  CompactLinkPreview.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 23/5/23.
//

import SwiftUI
import GlassRoomAPI
import GlassRoomTypes
import LinkPresentation
import UniformTypeIdentifiers

struct CompactLinkPreview: View {
    var url: URL

    @State var title: String = "Loading"
    @State var favicon: Image = .init(systemName: "globe")

    var body: some View {
        ZStack {
            HStack {
                favicon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                VStack {
                    Text(title)
                }
            }
        }
        .background {
            RoundedRectangle(cornerSize: .init(width: 16, height: 16))
                .fill(.regularMaterial)
        }
        .onAppear {
            load(url: url)
        }
    }

    func load(url: URL) {
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
                        DispatchQueue.main.async {
                            populateFrom(metadata: metadata)
                        }
                    case .failure(let failure):
                        Log.error("Failure: \(failure.localizedDescription)")
                    }
                }
            }
            return
        }

        // fallback: Normal LP Metadata cache
        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: url) { metadata, error in
            guard let metadata = metadata, error == nil else { return }
            DispatchQueue.main.async {
                populateFrom(metadata: metadata)
            }
        }
    }

    func populateFrom(metadata: LPLinkMetadata) {
        title = metadata.title ?? "Loading"

        metadata.imageProvider?.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier,
                                                       completionHandler: { (url, imageProviderError) in
            if imageProviderError != nil {
                return
            }
            favicon = .init(nsImage: NSImage(contentsOfFile: (url?.path)!)!)
        })
    }

    func driveIdFor(urlString: String) -> String? {
        guard urlString.contains("/docs.google.com/") || urlString.contains("/drive.google.com/")
        else { return nil }
        // detect the file id
        let fileIds = urlString.findMatches(pattern: "/d/[a-zA-Z0-9-_]+/")
        if let fileIdRaw = fileIds.first {
            let fileId = String(fileIdRaw.dropFirst(3).dropLast(1))
            return fileId
        }
        return nil
    }
}
