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
    
    @ObservedObject var courseAnnouncementsManager: GlobalCourseAnnouncementsDataManager = .global

    var body: some View {
        if selectedCourse != nil {
            VStack {
                List {
                    ForEach(courseAnnouncementsManager.courseAnnouncements, id: \.id) { announcement in
                        Button {
                            selectedPost = announcement
                        } label: {
                            VStack(alignment: .leading) {
                                Text(announcement.text)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                                
                                Text(announcement.creationTime)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(5)
                            .background(selectedPost?.id == announcement.id ? .blue : .clear)
                            .cornerRadius(6)
                        }
                        .buttonStyle(.plain)
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
            .onChange(of: selectedCourse) { _ in
                reloadAnnouncements()
            }
            .onAppear {
                reloadAnnouncements()
            }
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
    
    func reloadAnnouncements() {
        guard let selectedCourseId = selectedCourse?.id else { return }
        courseAnnouncementsManager.loadList(courseId: selectedCourseId)
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
