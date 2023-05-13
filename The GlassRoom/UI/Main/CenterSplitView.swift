//
//  CenterSplitView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 13/5/23.
//

import SwiftUI
import GlassRoomAPI

struct CenterSplitView: View {
    @Binding var selectedCourse: Course?
    //    @Binding var selectedPost:
    
    @ObservedObject var courseAnnouncementsManager: GlobalCourseAnnouncementsDataManager = .global

    var body: some View {
        VStack {
            Button("Reload") {
                reloadAnnouncements()
            }
            List {
                ForEach(courseAnnouncementsManager.courseAnnouncements, id: \.id) { announcement in
                    VStack(alignment: .leading) {
                        Text(announcement.text)
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            if courseAnnouncementsManager.loading {
                ProgressView()
                    .progressViewStyle(.linear)
                    .frame(maxWidth: .infinity)
                    .padding(10)
            }
        }
        .onAppear {
            reloadAnnouncements()
        }
    }
    
    func reloadAnnouncements() {
        guard let selectedCourseId = selectedCourse?.id else { return }
        print(selectedCourseId)
        courseAnnouncementsManager.loadList(courseId: selectedCourseId)
    }
}

struct CenterSplitView_Previews: PreviewProvider {
    static var previews: some View {
        CenterSplitView(selectedCourse: .constant(nil))
    }
}
