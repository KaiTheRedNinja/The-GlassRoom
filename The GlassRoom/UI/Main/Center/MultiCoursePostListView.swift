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

    @ObservedObject var announcementsManager: ObservableArray<CourseAnnouncementsDataManager>
    @ObservedObject var courseWorksManager: ObservableArray<CourseCourseWorksDataManager>

    init(selectedPost: Binding<CoursePost?>,
         displayOption: Binding<CenterSplitView.CourseDisplayOption>,
         announcements: ObservableArray<CourseAnnouncementsDataManager>,
         courseWorks: ObservableArray<CourseCourseWorksDataManager>
    ) {
        self._selectedPost = selectedPost
        self._displayOption = displayOption
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
        let announcements = announcementsManager.array.flatMap { $0.postData }
        let courseWorks = courseWorksManager.array.flatMap { $0.postData }
        var posts: [CoursePost] = []
        if displayOption != .courseWork {
            posts = announcements
        }
        if displayOption != .announcements {
            if posts.isEmpty {
                posts = courseWorks
            } else {
                posts.mergeWith(other: courseWorks,
                                isSame: { $0.id == $1.id },
                                isBefore: { $0.creationDate > $1.creationDate })
            }
        }
        return posts
    }
    var isEmpty: Bool { postData.isEmpty }
    var isLoading: Bool = false
    var hasNextPage: Bool = false

    func loadList(bypassCache: Bool) {
        if displayOption != .courseWork {
            for manager in announcementsManager.array {
                manager.loadList(bypassCache: bypassCache)
            }
        }
        if displayOption != .announcements {
            for manager in courseWorksManager.array {
                manager.loadList(bypassCache: bypassCache)
            }
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
