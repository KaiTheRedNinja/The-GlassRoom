//
//  CoursePostItem.swift
//  The GlassRoom
//
//  Created by Tristan on 14/05/2023.
//

import SwiftUI
import GlassRoomAPI

struct CoursePostItem: View {
    
    @State var announcement: CourseAnnouncement? = nil
    @State var coursework: CourseWork? = nil
    @Binding var selectedPost: CoursePost?
    
    var body: some View {
        if let coursework = self.coursework {
            listItemView(.courseWork(coursework), id: coursework.id, title: coursework.title, creationTime: coursework.creationTime, updateTime: coursework.updateTime)
        } else if let announcement = self.announcement {
            listItemView(.announcement(announcement), id: announcement.id, title: announcement.text, creationTime: announcement.creationTime, updateTime: announcement.updateTime)
        }
    }
    
    @ViewBuilder
    func listItemView(_ coursePostType: CoursePost?, id: String, title: String, creationTime: String, updateTime: String) -> some View {
        VStack {
            Button {
                selectedPost = coursePostType
            } label: {
                VStack(alignment: .leading) {
                    Text(title.replacingOccurrences(of: "\n", with: " "))
                        .font(.title3)
                        .fontWeight(.bold)
                        .lineLimit(2)
                    
                    HStack {
                        Image(systemName: "timer")
                        
                        Text(convertDate(creationTime, .long, .standard))
                        
                        if convertDate(updateTime) != convertDate(creationTime) {
                            // updateTime and creationTime are not the same
                            if convertDate(updateTime, .long, .omitted) == convertDate(creationTime, .long, .omitted) {
                                // updated on the same day, shows time instead
                                Text("(Edited \(convertDate(updateTime, .omitted, .standard)))")
                            } else {
                                // updated on different day, shows day instead
                                Text("(Edited \(convertDate(creationTime, .abbreviated, .omitted)))")
                            }
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(5)
                .background(selectedPost?.id == id ? .blue : .clear)
                .cornerRadius(6)
            }
            .buttonStyle(.plain)
            .padding(.vertical, 2)
        }
    }
}

struct CoursePostItem_Previews: PreviewProvider {
    static var previews: some View {
        Text("CoursePostItem()")
    }
}
