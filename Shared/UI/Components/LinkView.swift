//
//  LinkView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 11/10/23.
//

import SwiftUI
import LinkPresentation
import UniformTypeIdentifiers

protocol LinkViewDataProvider: ObservableObject, Hashable {
    var url: URL? { get }
    var title: String? { get }
#if os(macOS)
    var icon: NSImage? { get }
    var preview: NSImage? { get }
#else
    var icon: UIImage? { get }
    var preview: UIImage? { get }
#endif

    func loadData()
}

extension LinkViewDataProvider {
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
        hasher.combine(title)
        hasher.combine(icon == nil)
        hasher.combine(preview == nil)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

class DefaultLinkViewDataProvider: LinkViewDataProvider {
    @Published var url: URL?
    @Published var title: String?
#if os(macOS)
    @Published var icon: NSImage?
    @Published var preview: NSImage?
#else
    @Published var icon: UIImage?
    @Published var preview: UIImage?
#endif

    func loadData() {
        guard let url else { return }
        self.url = url
        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: url) { metadata, error in
            if let error {
                print("Error fetching data for \(url): \(error.localizedDescription)")
                return
            }
            if let metadata {
                print("Got metadata, loading things now :D")
                self.title = metadata.title
                Task {
                    if let iconProvider = metadata.iconProvider {
                        print("Got icon for \(url)")
                        self.icon = try await self.convertToImage(iconProvider)
                    }
                    if let imageProvider = metadata.imageProvider {
                        print("Got preview for \(url)")
                        self.preview = try await self.convertToImage(imageProvider)
                    }
                }
            } else {
                print("No metadata")
            }
        }
    }

#if os(macOS)
    func convertToImage(_ imageProvider: NSItemProvider?) async throws -> NSImage? {
        var image: NSImage?

        if let imageProvider {
            let type = String(describing: UTType.image)

            if imageProvider.hasItemConformingToTypeIdentifier(type) {
                let item = try await imageProvider.loadItem(forTypeIdentifier: type)

                if item is NSImage {
                    image = item as? NSImage
                }

                if item is URL {
                    guard let url = item as? URL,
                          let data = try? Data(contentsOf: url) else { return nil }

                    image = NSImage(data: data)
                }

                if item is Data {
                    guard let data = item as? Data else { return nil }

                    image = NSImage(data: data)
                }
            }
        }

        return image
    }
#else
    func convertToImage(_ imageProvider: NSItemProvider?) async throws -> UIImage? {
        var image: UIImage?

        if let imageProvider {
            let type = String(describing: UTType.image)

            if imageProvider.hasItemConformingToTypeIdentifier(type) {
                let item = try await imageProvider.loadItem(forTypeIdentifier: type)

                if item is UIImage {
                    image = item as? UIImage
                }

                if item is URL {
                    guard let url = item as? URL,
                          let data = try? Data(contentsOf: url) else { return nil }

                    image = UIImage(data: data)
                }

                if item is Data {
                    guard let data = item as? Data else { return nil }

                    image = UIImage(data: data)
                }
            }
        }

        return image
    }
#endif

#if os(macOS)
    init(url: URL? = nil, title: String? = nil, preview: NSImage? = nil) {
        self.url = url
        self.title = title
        self.preview = preview
    }
#else
    init(url: URL? = nil, title: String? = nil, preview: UIImage? = nil) {
        self.url = url
        self.title = title
        self.preview = preview
    }
#endif
}

struct LinkView<Provider: LinkViewDataProvider>: View {
    @ObservedObject var provider: Provider

    init(provider: Provider) {
        self.provider = provider
    }

    init(url: URL?) where Provider == DefaultLinkViewDataProvider {
        self.provider = .init(url: url)
    }

    var body: some View {
        VStack(alignment: .leading) {
            if let preview = provider.preview {
                Image(image: preview)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 250, maxHeight: 200)
                    .padding(.bottom, 16)
            }
            HStack {
                VStack(alignment: .leading) {
                    if let title = provider.title {
                        Text(title)
                            .bold()
                    }
                    Text(provider.url?.baseDomain ?? "Empty URL")
                        .opacity(0.8)
                }
            }
            .safeAreaInset(edge: .trailing) {
                if let icon = provider.icon, provider.preview == nil {
                    Image(image: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .cornerRadius(8)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
        }
        .frame(minHeight: 35)
        .animation(.default, value: provider)
        .font(.subheadline)
        .mask {
            RoundedRectangle(cornerRadius: 12)
        }
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThickMaterial)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                }
                .shadow(color: Color.black.opacity(0.25), radius: 10)
        }
        .contextMenu {
            if let url = provider.url {
                Button("Open Link") {
#if os(macOS)
                    NSWorkspace.shared.open(url)
#else
                    UIApplication.shared.open(url)
#endif
                }
            }
        } preview: {
            if let image = provider.preview {
                Image(image: image)
            }
        }
        .onAppear {
            provider.loadData()
        }
    }
}

extension Image {
#if os(macOS)
    init(image: NSImage) {
        self.init(nsImage: image)
    }
#else
    init(image: UIImage) {
        self.init(uiImage: image)
    }
#endif
}

extension URL {
    var baseDomain: String? {
        return self.host
    }
}
