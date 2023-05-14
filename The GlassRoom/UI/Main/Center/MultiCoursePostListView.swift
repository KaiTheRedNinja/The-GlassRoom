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
    @State var updateFlag: Int

    @ObservedObject var announcementsManager: ObservableArray<CourseAnnouncementsDataManager>
    @ObservedObject var courseWorksManager: ObservableArray<CourseCourseWorksDataManager>

    init(selectedPost: Binding<CoursePost?>,
         announcements: ObservableArray<CourseAnnouncementsDataManager>,
         courseWorks: ObservableArray<CourseCourseWorksDataManager>
    ) {
        self._selectedPost = selectedPost
        self.updateFlag = 0
        self.announcementsManager = announcements.observeChildrenChanges()
        self.courseWorksManager = courseWorks.observeChildrenChanges()
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
        // TODO: List of posts
        var posts: [CoursePost] = announcementsManager.array.flatMap { $0.postData }
        posts.mergeWith(other: courseWorksManager.array.flatMap { $0.postData },
                        isSame: { $0.id == $1.id },
                        isBefore: { $0.creationDate > $1.creationDate })
        return posts
    }
    var isEmpty: Bool { postData.isEmpty }
    var isLoading: Bool = false
    var hasNextPage: Bool = false

    func loadList(bypassCache: Bool) {
        for manager in announcementsManager.array {
            manager.loadList(bypassCache: bypassCache)
        }
        for manager in courseWorksManager.array {
            manager.loadList(bypassCache: bypassCache)
        }
    }
    func refreshList() {
        for manager in announcementsManager.array {
            manager.refreshList()
        }
        for manager in courseWorksManager.array {
            manager.refreshList()
        }
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
            let c = $0.objectWillChange.sink(receiveValue: { _ in self.objectWillChange.send() })

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
    var isLoading: Bool { get }
    var hasNextPage: Bool { get }

    func loadList(bypassCache: Bool)
    func refreshList()
}

extension CourseAnnouncementsDataManager: PostDataSource {
    var postData: [CoursePost] { courseAnnouncements.map({ .announcement($0) }) }
    var isEmpty: Bool { courseAnnouncements.isEmpty }
    var isLoading: Bool { loading }
    var hasNextPage: Bool { nextPageToken != nil }

    func refreshList() {
        refreshList(nextPageToken: nextPageToken)
    }
}

extension CourseCourseWorksDataManager: PostDataSource {
    var postData: [CoursePost] { courseWorks.map({ .courseWork($0) }) }
    var isEmpty: Bool { courseWorks.isEmpty }
    var isLoading: Bool { loading }
    var hasNextPage: Bool { nextPageToken != nil }

    func refreshList() {
        refreshList(nextPageToken: nextPageToken)
    }
}
