//
//  MainView.swift
//  The GlassRoom
//
//  Created by Tristan on 11/05/2023.
//

import SwiftUI
import GlassRoomAPI

struct MainView: View {
    @State var selectedCourse: GeneralCourse?
    @State var selectedPost: CoursePost?
    @State var showSearch: Bool = false

    @ObservedObject var userModel: UserAuthModel = .shared

    @ObservedObject var apiCalls: APILogger = .global
    @State var showApiCalls: Bool = false

    @AppStorage("debugMode") var debugMode: Bool = false

    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $selectedCourse)
        } content: {
            CenterSplitView(selectedCourse: $selectedCourse, selectedPost: $selectedPost)
                .frame(minWidth: 200)
        } detail: {
            DetailView(selectedCourse: $selectedCourse, selectedPost: $selectedPost)
                .frame(minWidth: 400)
        }
        .sheet(isPresented: $showSearch) {
            SearchView(selectedCourse: $selectedCourse,
                       selectedPost: $selectedPost)
        }
        .toolbar {
            if debugMode {
                Button {
                    showApiCalls.toggle()
                } label: {
                    Image(systemName: "arrow.left.arrow.right")
                }
                .popover(isPresented: $showApiCalls) { apiCallPopover }
            }

            Button {
                showSearch.toggle()
            } label: {
                Image(systemName: "magnifyingglass")
            }
            .keyboardShortcut("O", modifiers: [.command, .shift])
            
            Button {
                NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
            } label: {
                Image(systemName: "gearshape")
            }
        }
        .onAppear {
            loadCachedStreams()
        }
    }

    var apiCallPopover: some View {
        List {
            ForEach(apiCalls.apiHistory) { history in
                VStack(alignment: .leading) {
                    HStack {
                        Text(history.requestType)
                        Image(systemName: "arrow.right")
                        Text(history.expectedResponseType)
                    }
                    .font(.caption)
                    .bold()
                    Text(history.requestUrl)
                        .lineLimit(3)
                    GroupBox {
                        ScrollView(.horizontal, showsIndicators: false) {
                            VStack(alignment: .leading) {
                                ForEach(Array(history.parameters), id: \.key) { param in
                                    HStack {
                                        Text(param.key)
                                            .lineLimit(1)
                                            .frame(width: 150)
                                            .multilineTextAlignment(.leading)
                                        Text(param.value)
                                            .lineLimit(1)
                                    }
                                }
                            }
                        }
                    }
                    Divider()
                }
            }
        }
        .frame(width: 400, height: 300)
    }

    func loadCachedStreams() {
        let coursesManager = GlobalCoursesDataManager.global
        if coursesManager.courses.isEmpty {
            coursesManager.loadList()
        }
        let courses = coursesManager.courses
        for course in courses {
            let manager = CoursePostsDataManager.getManager(for: course.id)
            DispatchQueue.main.async {
                manager.loadList(onlyCache: true)
            }
        }
        print("Loaded managers: \(CoursePostsDataManager.loadedManagers.keys)")
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
