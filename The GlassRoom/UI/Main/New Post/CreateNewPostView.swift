//
//  CreateNewPostView.swift
//  The GlassRoom
//
//  Created by Tristan on 19/05/2023.
//

import SwiftUI

struct CreateNewPostView: View {
    
    var onCreateAnnouncement: (() -> Void)?
    var onCreateCourseWork: (() -> Void)?
    var onCreateCourseWorkMaterial: (() -> Void)?
    
    var body: some View {
        VStack {
            Text("Hello, World!")
        }
        .frame(width: 450, height: 400)
    }
}

struct CreateNewPostView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewPostView()
    }
}
