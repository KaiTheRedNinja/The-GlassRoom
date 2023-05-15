//
//  MultiCoursePostListView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 14/5/23.
//

import SwiftUI
import Combine

struct MultiCoursePostListView: View {
    @Binding var selectedPost: CoursePost?
    @Binding var displayOption: CenterSplitView.CourseDisplayOption
    @State var updateFlag: Int

    @ObservedObject var postsManager: ObservableArray<CoursePostsDataManager>

    init(selectedPost: Binding<CoursePost?>,
         displayOption: Binding<CenterSplitView.CourseDisplayOption>,
         posts: ObservableArray<CoursePostsDataManager>
    ) {
        self._selectedPost = selectedPost
        self._displayOption = displayOption
        self.updateFlag = 0
        self.postsManager = posts.observeChildrenChanges()
    }

    var body: some View {
        CoursePostListView(selectedPost: $selectedPost,
                           postData: postData,
                           isEmpty: isEmpty,
                           isLoading: isLoading,
                           hasNextPage: hasNextPage,
                           loadList: loadList,
                           refreshList: refreshList)
    }

    var postData: [CoursePost] {
        let posts = postsManager.array.flatMap({ $0.postData })
        switch displayOption {
        case .allPosts:
            return posts
        case .announcements:
            return posts.filter {
                switch $0 {
                case .announcement(_): return true
                case .courseWork(_): return false
                }
            }
        case .courseWork:
            return posts.filter {
                switch $0 {
                case .announcement(_): return false
                case .courseWork(_): return true
                }
            }
        }
    }
    var isEmpty: Bool { postData.isEmpty }
    var isLoading: Bool = false
    var hasNextPage: Bool = false

    func loadList(bypassCache: Bool) {
        postsManager.array.forEach({ $0.loadList(bypassCache: bypassCache) })
    }

    func refreshList() {
        postsManager.array.forEach({ $0.refreshList() })
    }
}

class ObservableArray<T: PostDataSource>: ObservableObject {

    @Published var array: [T] = []
    var cancellables = [AnyCancellable]()

    init(array: [T]) {
        self.array = array
    }

    func observeChildrenChanges<T: ObservableObject>() -> ObservableArray<T> {
        let array2 = array as! [T]
        array2.forEach({
            let c = $0.objectWillChange.sink(receiveValue: { _ in
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            })

            // Important: You have to keep the returned value allocated,
            // otherwise the sink subscription gets cancelled
            self.cancellables.append(c)
        })
        return self as! ObservableArray<T>
    }
}

protocol PostDataSource: ObservableObject {
    var postData: [CoursePost] { get }
    var isEmpty: Bool { get }
    var loading: Bool { get }
    var hasNextPage: Bool { get }

    func loadList(bypassCache: Bool)
    func refreshList(requestNextPageIfExists: Bool)
}

extension CoursePostsDataManager: PostDataSource {
    var isEmpty: Bool {
        courseAnnouncements.isEmpty && courseCourseWorks.isEmpty
    }
}
