//
//  DetailView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 13/5/23.
//


import SwiftUI
import GlassRoomAPI
import LinkPresentation

struct DetailView: View {
    @Binding var selectedCourse: Course?
    @Binding var selectedPost: CourseAnnouncement?

    var body: some View {
        if selectedPost != nil {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text(selectedPost?.text ?? "error")
                        Spacer()
                    }
                    
                    Spacer()
                    
                    if selectedPost?.materials != nil {
                        Divider()
                        
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach((selectedPost?.materials!)!, id: \.id) { material in
                                    if let driveFile = material.driveFile {
                                        LinkPreview(url: URL(string: driveFile.driveFile.alternateLink)!)
//                                            .frame(height: 100)
//                                            .scaledToFit()
                                    }
                                    
                                    if let youtubeVideo = material.youtubeVideo {
                                        LinkPreview(url: URL(string: youtubeVideo.alternateLink)!)
//                                            .frame(height: 100)
//                                            .scaledToFit()
                                    }
                                    
                                    if let form = material.form {
                                        LinkPreview(url: URL(string: form.formURL)!)
//                                            .frame(height: 100)
//                                            .scaledToFit()
                                    }
                                    
                                    if let materialLink = material.link {
                                        LinkPreview(url: URL(string: materialLink.url)!)
//                                            .frame(height: 100)
//                                            .scaledToFit()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.all)
        } else {
            VStack {
                Text("Course: \(selectedCourse?.name ?? "nothing")")
                Text("No Post Selected")
            }
        }
    }
    
    func iterateThroughLinks(materials: [AssignmentMaterial]) -> [[String : String]] {
        var returnResults: [[String : String]] = []
        
        materials.forEach { material in
            let linkInfo = getLinkInformation(material: material)
            var isntEmptyLink = true
            
            for (title, url) in linkInfo {
                if title == "" && url == "" {
                    isntEmptyLink = false
                }
            }
            
            if isntEmptyLink {
                returnResults.append(linkInfo)
            }
        }
        
        return returnResults
    }
    
    func getLinkInformation(material: AssignmentMaterial) -> [String : String] {
        
        var returnResults: [String : String] = ["" : ""]
        
        if material.driveFile?.driveFile.alternateLink ?? "nil" != "nil" {
            guard let driveFileTitle = material.driveFile?.driveFile.title else { return returnResults }
            guard let driveFileLink = material.driveFile?.driveFile.alternateLink else { return returnResults }
            
            returnResults = [driveFileTitle : driveFileLink]
        } else if material.form?.formURL ?? "nil" != "nil" {
            guard let formTitle = material.form?.title else { return returnResults }
            guard let formURL = material.form?.formURL else { return returnResults }
            
            returnResults = [formTitle : formURL]
        } else if material.link?.url ?? "nil" != "nil" {
            guard let linkTitle = material.link?.title else { return returnResults }
            guard let linkURL = material.link?.url else { return returnResults }
            
            returnResults = [linkTitle : linkURL]
        } else if material.youtubeVideo?.alternateLink ?? "nil" != "nil" {
            guard let ytTitle = material.youtubeVideo?.title else { return returnResults }
            guard let ytURL = material.youtubeVideo?.alternateLink else { return returnResults }
            
            returnResults = [ytTitle : ytURL]
        }
        
        return returnResults
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(selectedCourse: .constant(nil), selectedPost: .constant(nil))
    }
}


struct LinkPreview: NSViewRepresentable {
    typealias NSViewType = LPLinkView
    
    var url: URL
    
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
