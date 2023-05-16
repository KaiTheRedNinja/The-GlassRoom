//
//  CoursePostItem.swift
//  The GlassRoom
//
//  Created by Tristan on 14/05/2023.
//

import SwiftUI
import GlassRoomAPI

struct CoursePostItem: View {

    var coursePost: CoursePost
    
    var body: some View {
        HStack {
            VStack {
                switch coursePost {
                case .announcement(_):
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.accentColor)
                case .courseWork(_):
                    Image(systemName: "megaphone")
                        .foregroundColor(.accentColor)
                case .courseMaterial(_):
                    Image(systemName: "doc")
                        .foregroundColor(.accentColor)
                }
                Spacer()
            }
            .frame(width: 15)

            switch coursePost {
            case .announcement(let announcement):
                listItemView(coursePost,
                             id: announcement.id,
                             title: announcement.text,
                             creationTime: announcement.creationTime,
                             updateTime: announcement.updateTime)
            case .courseWork(let coursework):
                listItemView(coursePost,
                             id: coursework.id,
                             title: coursework.title,
                             creationTime: coursework.creationTime,
                             updateTime: coursework.updateTime,
                             dueDate: coursework.dueDate,
                             dueTime: coursework.dueTime)
            case .courseMaterial(let coursematerial):
                listItemView(coursePost,
                             id: coursematerial.id,
                             title: coursematerial.title,
                             creationTime: coursematerial.creationTime,
                             updateTime: coursematerial.updateTime)
            }
        }
    }
    
    @ViewBuilder
    func listItemView(_ coursePostType: CoursePost?,
                      id: String,
                      title: String,
                      creationTime: String,
                      updateTime: String,
                      dueDate: DueDate? = nil,
                      dueTime: TimeOfDay? = nil) -> some View {
        VStack(alignment: .leading) {
            Text(title.replacingOccurrences(of: "\n", with: " "))
                .font(.body)
                .fontWeight(.bold)
                .lineLimit(1)

            HStack {
                Image(systemName: "timer")

                Text(convertDate(creationTime, .abbreviated, .standard))
                    .offset(x: 1.5)
            }
            .lineLimit(2)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .offset(x: 1.5)
            
            if convertDate(updateTime) != convertDate(creationTime) {
                // updateTime and creationTime are not the same
                HStack {
                    Image(systemName: "pencil")
                    Text("\(convertDate(updateTime, .abbreviated, .standard))")
                        .offset(x: 3)
                }
                .lineLimit(1)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .offset(x: 2)
            }

            if let dueDate = dueDate {
                HStack {
                    Image(systemName: "calendar")
                    if let dueTime = dueTime {
                        Text("\(dueDate.day)/\(dueDate.month)/\(dueDate.year) - \(getTimeFromDueTime(dueTime))".replacingOccurrences(of: ",", with: ""))
                            .offset(x: 1)
                    } else {
                        Text("\(dueDate.day)/\(dueDate.month)/\(dueDate.year)".replacingOccurrences(of: ",", with: ""))
                            .offset(x: 1)
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                .offset(x: 1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func getTimeFromDueTime(_ dueTime: TimeOfDay) -> String {
        guard let hours = dueTime.hours else {
            guard let minutes = dueTime.minutes else { return "-" }
            return "00:\(minutes)"
        }
        guard let minutes = dueTime.minutes else { return "\((hours + 8) % 24):00" }
        
        return "\((hours + 8) % 24):\(minutes)"
    }
}

struct CoursePostItem_Previews: PreviewProvider {
    static var previews: some View {
        Text("CoursePostItem()")
    }
}
