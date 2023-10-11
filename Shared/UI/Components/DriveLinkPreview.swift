//
//  DriveLinkPreview.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 11/10/23.
//

import SwiftUI
import LinkPresentation
import UniformTypeIdentifiers
import GlassRoomTypes

final class DriveLinkDataProvider: LinkViewDataProvider {
    @Published var url: URL?
    @Published var title: String?
    @Published var preview: NSImage?

    var icon: NSImage? { nil } // never gonna exist

    var driveFile: DriveFile

    init(driveFile: DriveFile) {
        self.driveFile = driveFile
        self.url = URL(string: driveFile.alternateLink)
        self.title = driveFile.title
    }

    func loadData() {
        self.url = URL(string: driveFile.alternateLink)
        self.title = driveFile.title ?? "Untitled Drive File"

        if let thumbnailUrlString = driveFile.thumbnailUrl,
           let thumbnailUrl = URL(string: thumbnailUrlString + "?access_token=" + APISecretManager.accessToken) {

            loadQueue.async {
                print("Loading the URL")
                #if os(macOS)
                guard let imageData = try? Data(contentsOf: thumbnailUrl),
                      let image = NSImage(data: imageData)
                else { return }
                #else
                guard let imageData = try? Data(contentsOf: thumbnailUrl),
                      let image = UIImage(data: imageData)
                else { return }
                #endif

                self.preview = image
            }

            print(thumbnailUrl)
        }
    }
}

extension LinkView {
    init(driveFile: DriveFile) where Provider == DriveLinkDataProvider {
        self.init(provider: DriveLinkDataProvider(driveFile: driveFile))
    }
}
