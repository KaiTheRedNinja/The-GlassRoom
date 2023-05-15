//
//  LinkPreview.swift
//  The GlassRoom
//
//  Created by Tristan on 14/05/2023.
//

import AppKit
import SwiftUI
import LinkPresentation

struct LinkPreview: NSViewRepresentable {
    typealias NSViewType = LPLinkView
    
    var url: URL

    init(url: URL) {
        self.url = url
    }
    
    func makeNSView(context: NSViewRepresentableContext<LinkPreview>) -> LinkPreview.NSViewType {
        return LPLinkView(url: url)
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
