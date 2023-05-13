//
//  MainView.swift
//  The GlassRoom
//
//  Created by Tristan on 11/05/2023.
//

import SwiftUI
import GlassRoomAPI

struct MainView: View {
    @State var selectedCourse: Course?
    @State var selectedPost: CourseAnnouncement?

    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $selectedCourse)
        } content: {
            CenterSplitView(selectedCourse: $selectedCourse, selectedPost: $selectedPost)
        } detail: {
            DetailView(selectedCourse: $selectedCourse, selectedPost: $selectedPost)
        }
        .toolbar {
            Button("Log Out") {
                UserAuthModel.shared.signOut()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
