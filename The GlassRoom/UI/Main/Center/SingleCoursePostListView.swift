//
//  SingleCoursePostListView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 15/5/23.
//

import SwiftUI

struct SingleCoursePostListView: View {
    @Binding var selectedPost: CoursePost?
    @Binding var displayOption: CenterSplitView.CourseDisplayOption
    @State var updateFlag: Int

    @ObservedObject var postsManager: CoursePostsDataManager

    init(selectedPost: Binding<CoursePost?>,
         displayOption: Binding<CenterSplitView.CourseDisplayOption>,
         posts: CoursePostsDataManager
    ) {
        self._selectedPost = selectedPost
        self._displayOption = displayOption
        self.updateFlag = 0
        self.postsManager = posts
    }

    var body: some View {
        CoursePostListView(selectedPost: $selectedPost,
                           postData: postsManager.postData,
                           isEmpty: postsManager.isEmpty,
                           isLoading: postsManager.loading,
                           hasNextPage: postsManager.hasNextPage,
                           loadList: postsManager.loadList,
                           refreshList: { postsManager.refreshList() })
    }
}
