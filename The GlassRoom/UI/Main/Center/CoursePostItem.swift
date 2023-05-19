//
//  CoursePostItem.swift
//  The GlassRoom
//
//  Created by Tristan on 14/05/2023.
//

import SwiftUI
import GlassRoomTypes

struct CoursePostItem: View {

    var coursePost: CoursePost

    @ObservedObject var profilesManager: GlobalUserProfilesDataManager = .global

    @AppStorage("useSenderPfpAsIcon") var useSenderPfpAsIcon: Bool = true

    var body: some View {
        HStack {
            VStack {
                switch coursePost {
                case .announcement(let announcement):
                    AsyncImage(url: useSenderPfpAsIcon ? URL(
                        string: "https:" + (profilesManager.userProfilesMap[announcement.creatorUserId]?.photoUrl ?? "")
                    ) : nil) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .mask { Circle() }
                    } placeholder: {
                        Image(systemName: "megaphone")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.accentColor)
                            .frame(width: 20, height: 20)
                    }
                case .courseWork(_):
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.accentColor)
                        .frame(width: 20, height: 20)
                case .courseMaterial(_):
                    Image(systemName: "doc")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.accentColor)
                        .frame(width: 20, height: 20)
                }
                Spacer()
            }
            .padding(.top, 5)
            .frame(width: 30)

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
                .lineLimit(2)

            HStack {
                Image(systemName: "timer")

                Text(convertDate(creationTime, .abbreviated, .standard))
                    .offset(x: 1.5)
            }
            .lineLimit(1)
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
                .lineLimit(1)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .offset(x: 1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func getTimeFromDueTime(_ dueTime: TimeOfDay) -> String {
        guard let hours = dueTime.hours else {
            guard let minutes = dueTime.minutes else { return "-" } // no time
            // only minutes
            let string = "00:\(minutes)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.date(from: string)
            
            return string
        }
        guard let minutes = dueTime.minutes else {
            // only hours
            let string = "\((hours + 8) % 24):00"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.date(from: string)
            
            return string
            
        }
        
        // hours and minutes
        let string = "\((hours + 8) % 24):\(minutes)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.date(from: string)
        
        return string
    }
}

struct CoursePostItem_Previews: PreviewProvider {
    static var previews: some View {
        Text("CoursePostItem()")
    }
}
