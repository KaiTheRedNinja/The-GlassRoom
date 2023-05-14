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
    @State var showSearch: Bool = false

    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $selectedCourse)
        } content: {
            CenterSplitView(selectedCourse: $selectedCourse, selectedPost: $selectedPost)
        } detail: {
            DetailView(selectedCourse: $selectedCourse, selectedPost: $selectedPost)
        }
        .sheet(isPresented: $showSearch) {
            SearchView(selectedCourse: $selectedCourse,
                       selectedPost: $selectedPost)
        }
        .toolbar {
            Button {
                showSearch.toggle()
            } label: {
                Image(systemName: "magnifyingglass")
            }
            Button {
                UserAuthModel.shared.signOut()
            } label: {
                Image(systemName: "eject")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
