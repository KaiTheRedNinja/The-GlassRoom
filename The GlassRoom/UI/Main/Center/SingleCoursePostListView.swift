//
//  SingleCoursePostListView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 15/5/23.
//

import SwiftUI
import GlassRoomTypes

struct SingleCoursePostListView: View {
    @Binding var selectedPost: CoursePost?
    @Binding var displayOption: CenterSplitView.CourseDisplayOption
    @State var updateFlag: Int
    @State var plusPressed = false

    @ObservedObject var postsManager: CoursePostsDataManager
    @ObservedObject var profilesManager: GlobalUserProfilesDataManager = .global

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
        switch displayOption {
        case .userRegister:
            CourseRegisterListView(teachers: profilesManager.teachers[postsManager.courseId] ?? [],
                                   students: profilesManager.students[postsManager.courseId] ?? [],
                                   isEmpty: (profilesManager.teachers[postsManager.courseId] ?? []).isEmpty &&
                                            (profilesManager.students[postsManager.courseId] ?? []).isEmpty,
                                   isLoading: false,
                                   hasNextPage: false,
                                   loadList: { _ in profilesManager.loadProfiles(for: postsManager.courseId) },
                                   refreshList: { profilesManager.loadProfiles(for: postsManager.courseId) })
            .onAppear {
                GlobalUserProfilesDataManager.global.loadProfiles(for: postsManager.courseId)
            }
        default:
            CoursePostListView(selectedPost: $selectedPost,
                               postData: postData,
                               isEmpty: postsManager.isEmpty,
                               isLoading: postsManager.loading,
                               hasNextPage: postsManager.hasNextPage,
                               loadList: { postsManager.loadList(bypassCache: $0) },
                               refreshList: { postsManager.refreshList() },
                               onPlusPress: { plusPressed.toggle() })
            .sheet(isPresented: $plusPressed) {
                CreateNewPostView(onCreateAnnouncement: {

                }, onCreateCourseWork: {

                }, onCreateCourseWorkMaterial: {

                })
            }
        }
    }

    var postData: [CoursePost] {
        let posts = postsManager.postData
        switch displayOption {
        case .allPosts:
            return posts
        case .announcements:
            return posts.filter {
                switch $0 {
                case .announcement(_): return true
                default: return false
                }
            }
        case .courseWork:
            return posts.filter {
                switch $0 {
                case .courseWork(_): return true
                default: return false
                }
            }
        case .courseMaterial:
            return posts.filter {
                switch $0 {
                case .courseMaterial(_): return true
                default: return false
                }
            }
        default: return []
        }
    }
}
