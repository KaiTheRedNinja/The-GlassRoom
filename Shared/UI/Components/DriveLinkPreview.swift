//
//  DriveLinkPreview.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 11/10/23.
//

import SwiftUI
import LinkPresentation
import GlassRoomAPI
import GlassRoomTypes

struct DriveLinkPreview {
    var driveFile: DriveFile

    init(driveFile: DriveFile) {
        self.driveFile = driveFile
    }
}

#if os(macOS)
import AppKit
extension DriveLinkPreview: NSViewRepresentable {
    typealias NSViewType = LPLinkView

    func makeNSView(context: NSViewRepresentableContext<DriveLinkPreview>) -> DriveLinkPreview.NSViewType {
        let linkView = LPLinkView()
        let metadata = LPLinkMetadata()

        print("DETAILS:")
        print(driveFile.title ?? "Untitled")
        print(driveFile.alternateLink)

        metadata.url = URL(string: driveFile.alternateLink)
        metadata.title = driveFile.title ?? "Untitled Drive File"
        if let thumbnailUrlString = driveFile.thumbnailUrl,
           let thumbnailUrl = URL(string: thumbnailUrlString + "?access_token=" + APISecretManager.accessToken) {
            metadata.imageProvider = .init(contentsOf: thumbnailUrl)
            print(thumbnailUrl)
        }

        linkView.metadata = metadata

        return linkView
    }

    func updateNSView(_ nsView: DriveLinkPreview.NSViewType, context: NSViewRepresentableContext<DriveLinkPreview>) {
    }
}
#else
import UIKit
extension DriveLinkPreview: UIViewRepresentable {
    typealias UIViewType = LPLinkView

    func makeUIView(context: UIViewRepresentableContext<DriveLinkPreview>) -> DriveLinkPreview.UIViewType {
        let linkView = LPLinkView()
        linkView.metadata.url = URL(string: driveFile.alternateLink)
        linkView.metadata.title = driveFile.title
        if let thumbnailUrlString = driveFile.thumbnailUrl, let thumbnailUrl = URL(string: thumbnailUrlString) {
            linkView.metadata.imageProvider = .init(contentsOf: thumbnailUrl)
        }

        return linkView
    }

    func updateUIView(_ nsView: DriveLinkPreview.NSViewType, context: UIViewRepresentableContext<DriveLinkPreview>) {
    }
}
#endif
