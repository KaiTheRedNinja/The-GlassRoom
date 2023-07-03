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

    @ObservedObject var postsManager: ObservableArray<CoursePostsDataManager>
    @ObservedObject var displayedCourseManager: DisplayedCourseManager

    @State var postData: [CoursePost] = []

    init(selectedPost: Binding<CoursePost?>,
         displayOption: Binding<CenterSplitView.CourseDisplayOption>,
         displayedCourseIds: DisplayedCourseManager
    ) {
        self._selectedPost = selectedPost
        self._displayOption = displayOption

        self.displayedCourseManager = displayedCourseIds
        self.postsManager = .init(array: displayedCourseIds.displayedAggregateCourseIds.map { value in
            CoursePostsDataManager.getManager(for: value)
        }).observeChildrenChanges()

        updatePostData()
    }

    var body: some View {
        switch displayOption {
        case .userRegister:
            // TODO: User register list for multiple courses
            Text("User Register List")
        default:
            UniversalCoursePostListView(isInSearch: false,
                                        selectedPost: $selectedPost,
                               showPostCourseOrigin: true,
                               postData: postData,
                               isLoading: isLoading,
                               hasNextPage: hasNextPage,
                               loadList: loadList,
                               refreshList: refreshList)
            .onChange(of: displayedCourseManager.displayedAggregateCourseIds) { _ in
                postsManager.array = displayedCourseManager.displayedAggregateCourseIds.map { value in
                    let manager = CoursePostsDataManager.getManager(for: value)
                    if manager.postData.isEmpty {
                        manager.loadList()
                    }
                    return manager
                }
                updatePostData()
            }
            .onChange(of: displayOption) { _ in
                updatePostData()
            }
        }
    }

    func updatePostData() {
        let posts = postsManager.array.flatMap({ $0.postData })
        switch displayOption {
        case .allPosts:
            postData = posts
        case .announcements:
            postData = posts.filter {
                switch $0 {
                case .announcement(_): return true
                default: return false
                }
            }
        case .courseWork:
            postData = posts.filter {
                switch $0 {
                case .courseWork(_): return true
                default: return false
                }
            }
        case .courseMaterial:
            postData = posts.filter {
                switch $0 {
                case .courseMaterial(_): return true
                default: return false
                }
            }
        default: postData = []
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

    @Published var array: [T] = [] {
        didSet { trimWatchers(oldArray: oldValue, newArray: array) }
    }
    var cancellables: [String: AnyCancellable] = [:]

    init(array: [T]) {
        self.array = array
    }

    deinit {
        cancellables.forEach({ $0.value.cancel() })
        cancellables = [:]
    }

    func trimWatchers(oldArray: [T], newArray: [T]) {
        // if stuff from the old array is missing in the new array, remove them
        for oldItem in oldArray {
            if !newArray.contains(where: { $0.courseId == oldItem.courseId }) {
                cancellables[oldItem.courseId]?.cancel()
                cancellables.removeValue(forKey: oldItem.courseId)
            }
        }

        // if stuff from the new array is not in the old array, add watchers
        for newItem in newArray {
            if !oldArray.contains(where: { $0.courseId == newItem.courseId }) {
                let watcher = newItem.objectWillChange.sink(receiveValue: { _ in
                    DispatchQueue.main.async {
                        self.objectWillChange.send()
                    }
                })

                // Important: You have to keep the returned value allocated,
                // otherwise the sink subscription gets cancelled
                self.cancellables[newItem.courseId] = watcher
            }
        }
    }

    func observeChildrenChanges() -> ObservableArray<T> {
        trimWatchers(oldArray: [], newArray: array)
        return self
    }
}

protocol PostDataSource: ObservableObject {
    var courseId: String { get }
    var postData: [CoursePost] { get }
    var isEmpty: Bool { get }
    var loading: Bool { get }
    var hasNextPage: Bool { get }

    func loadList(bypassCache: Bool, onlyCache: Bool)
    func refreshList(requestNextPageIfExists: Bool)
}

extension CoursePostsDataManager: PostDataSource {
    var isEmpty: Bool {
        courseAnnouncements.isEmpty && courseCourseWorks.isEmpty
    }
}
