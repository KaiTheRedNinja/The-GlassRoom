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
    @Binding var selectedPost: CourseAnnouncement?

    @State var courseAnnouncementManager: CourseAnnouncementsDataManager?

    var body: some View {
        ZStack {
            if let courseAnnouncementManager {
                CourseContentsListView(selectedPost: $selectedPost,
                                       courseAnnouncementsManager: courseAnnouncementManager)
            } else {
                VStack {
                    Text("No Course Selected")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                }
            }
        }
        .onChange(of: selectedCourse) { _ in
            reloadAnnouncements()
        }
        .onAppear {
            reloadAnnouncements()
        }
    }
    
    func reloadAnnouncements() {
        guard let selectedCourseId = selectedCourse?.id else {
            self.courseAnnouncementManager = nil
            return
        }
        let manager = CourseAnnouncementsDataManager.getManager(for: selectedCourseId)
        self.courseAnnouncementManager = manager
        if manager.courseAnnouncements.isEmpty {
            manager.loadList(bypassCache: true)
        }
        // TODO: Intelligently refresh
    }
    
    func convertDate(dateString: String) -> String {
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        if let dt = dtFormatter.date(from: dateString) {
            return dt.description
        }
        
        return ""
    }
}

struct CenterSplitView_Previews: PreviewProvider {
    static var previews: some View {
        CenterSplitView(selectedCourse: .constant(nil), selectedPost: .constant(nil))
    }
}
