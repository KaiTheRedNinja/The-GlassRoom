//
//  SingleCoursePostListView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 15/5/23.
//

import SwiftUI
import GlassRoomTypes
import GlassRoomInterface

struct SingleCoursePostListView: View {
    
    @State var isInSearch: Bool
    
    @Binding var selectedPost: CoursePost?
    @Binding var displayOption: CourseDisplayOption
    @State var updateFlag: Int
    @State var plusPressed = false

    @ObservedObject var postsManager: CoursePostsDataManager
    @ObservedObject var profilesManager: GlobalUserProfilesDataManager = .global
    @ObservedObject var coursesManager: GlobalCoursesDataManager = .global

    init(selectedPost: Binding<CoursePost?>,
         displayOption: Binding<CourseDisplayOption>,
         posts: CoursePostsDataManager,
         isInSearch: Bool
    ) {
        self._selectedPost = selectedPost
        self._displayOption = displayOption
        self.updateFlag = 0
        self.postsManager = posts
        self.isInSearch = isInSearch
    }

    var body: some View {
        switch displayOption {
        case .resources:
            CourseResourcesListView(
                currentPage: $displayOption,
                courseMaterials: postsManager.courseCourseMaterials,
                course: coursesManager.courseIdMap[postsManager.courseId], isEmpty: postsManager.courseCourseMaterials.isEmpty,
                isLoading: postsManager.courseWorksLoading,
                hasNextPage: postsManager.courseWorksNextPageToken != nil,
                loadList: { postsManager.loadList(bypassCache: $0) },
                refreshList: { postsManager.refreshList() },
                postsManager: postsManager
            )
            .onAppear {
                postsManager.loadList()
            }
            //        case .userRegister:
            //            CourseRegisterListView(
            //                teachers: profilesManager.teachers[postsManager.courseId] ?? [],
            //                students: profilesManager.students[postsManager.courseId] ?? [],
            //                isEmpty: (profilesManager.teachers[postsManager.courseId] ?? []).isEmpty &&
            //                         (profilesManager.students[postsManager.courseId] ?? []).isEmpty,
            //                isLoading: profilesManager.loading,
            //                hasNextPage: profilesManager.hasNextPage,
            //                loadList: { profilesManager.loadList(for: postsManager.courseId, bypassCache: $0) },
            //                refreshList: { profilesManager.refreshList(for: postsManager.courseId) }
            //            )
            //            #if os(iOS)
            //            .toolbar {
            //                    ToolbarItem(placement: .status) {
            //                        if let course = coursesManager.courseIdMap[postsManager.courseId] {
            //                            Text(configuration.nameFor(course))
            //                                .padding(.horizontal)
            //                                .font(.subheadline)
            //                                .fontWeight(.bold)
            //                        }
            //                    }
            //            }
            //            #endif
            //            .onAppear {
            //                profilesManager.loadList(for: postsManager.courseId)
            //            }
        default:
            UniversalCoursePostListView(
                isInSearch: isInSearch,
                currentPage: $displayOption,
                selectedPost: $selectedPost,
                course: coursesManager.courseIdMap[postsManager.courseId],
                postData: postData,
                isLoading: postsManager.loading,
                hasNextPage: postsManager.hasNextPage,
                loadList: { postsManager.loadList(bypassCache: $0) },
                refreshList: { postsManager.refreshList() },
                onPlusPress: { plusPressed.toggle() },
                postsManager: postsManager
            )
            .sheet(isPresented: $plusPressed) {
                CreateNewPostView(onCreatePost: { post in
                    switch post {
                    case .announcement(let announcement):
                        postsManager.createNewAnnouncement(courseId: postsManager.courseId,
                                                           id: announcement.id,
                                                           text: announcement.text,
                                                           materials: announcement.materials,
                                                           state: announcement.state,
                                                           alternateLink: announcement.alternateLink,
                                                           creationTime: announcement.creationTime,
                                                           updateTime: announcement.updateTime,
                                                           scheduledTime: announcement.scheduledTime,
                                                           assigneeMode: announcement.assigneeMode,
                                                           individualStudentsOptions: announcement.individualStudentsOptions,
                                                           creatorUserId: announcement.creatorUserId)
                        
                    case .courseWork(let courseWork):
                        postsManager.createNewCourseWork(courseId: postsManager.courseId,
                                                         id: courseWork.id,
                                                         title: courseWork.title,
                                                         description: courseWork.description,
                                                         materials: courseWork.materials,
                                                         state: courseWork.state,
                                                         alternateLink: courseWork.alternateLink,
                                                         creationTime: courseWork.creationTime,
                                                         updateTime: courseWork.updateTime,
                                                         dueDate: courseWork.dueDate,
                                                         dueTime: courseWork.dueTime,
                                                         scheduledTime: courseWork.scheduledTime,
                                                         maxPoints: courseWork.maxPoints,
                                                         workType: courseWork.workType,
                                                         associatedWithDeveloper: courseWork.associatedWithDeveloper,
                                                         assigneeMode: courseWork.assigneeMode,
                                                         individualStudentsOptions: courseWork.individualStudentsOptions,
                                                         submissionModificationMode: courseWork.submissionModificationMode,
                                                         creatorUserId: courseWork.creatorUserId,
                                                         topicId: courseWork.topicId,
                                                         gradeCategory: courseWork.gradeCategory,
                                                         assignment: courseWork.assignment,
                                                         multipleChoiceQuestion: courseWork.multipleChoiceQuestion)
                        
                    case .courseMaterial(let courseMaterial):
                        postsManager.createNewCourseWorkMaterial(courseId: postsManager.courseId,
                                                                 id: courseMaterial.id,
                                                                 title: courseMaterial.title,
                                                                 description: courseMaterial.description,
                                                                 materials: courseMaterial.materials,
                                                                 state: courseMaterial.state,
                                                                 alternateLink: courseMaterial.alternateLink,
                                                                 creationTime: courseMaterial.creationTime,
                                                                 updateTime: courseMaterial.updateTime,
                                                                 scheduledTime: courseMaterial.scheduledTime,
                                                                 assigneeMode: courseMaterial.assigneeMode,
                                                                 individualStudentsOptions: courseMaterial.individualStudentsOptions,
                                                                 creatorUserId: courseMaterial.creatorUserId,
                                                                 topicId: courseMaterial.topicId)
                    }
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
