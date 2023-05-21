//
//  CoursePostListView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 21/5/23.
//

import SwiftUI

/// this is not intended to be used outside a `List`
struct CoursePostListView: View {
    var postData: [CoursePost]
    var showPostCourseOrigin: Bool = false
    var showTimeIndicators: Bool = true

    @ObservedObject var courseManager: GlobalCoursesDataManager = .global

    var body: some View {
        ForEach(Array(postData.enumerated()), id: \.1.id) { (index, post) in
            let thisPostTimeBatch = getTimeBatch(for: postData[index].creationDate)
            if index == 0 || getTimeBatch(for: postData[index-1].creationDate) != thisPostTimeBatch {
                HStack {
                    Text(thisPostTimeBatch.description)
                        .bold()
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.horizontal, 5)
                .disabled(true)
            }
            VStack {
                if showPostCourseOrigin, let firstOccurence = courseManager.courses.first(where: { $0.id == post.courseId }) {
                    HStack {
                        Text(courseManager.configuration.nameFor(firstOccurence.name))
                            .bold()
                            .foregroundColor(.gray)
                            .font(.caption)
                            .lineLimit(1)
                        Spacer()
                    }
                    .padding(.bottom, -5)
                }
                CoursePostItem(coursePost: post)
                    .padding(.vertical, 2.5)
            }
            .tag(post)
        }
    }

    // time batches are as follows, and are shown in between posts of different time batches:
    //
    // today
    // yesterday
    // [day of week] (for one week)
    // this month (if today's date is > 7)
    // last month
    // this year
    // last year
    // [year number]

    enum TimeBatch: Hashable {
        case today
        case yesterday
        case dayOfWeek(DayOfWeek)
        case thisMonth
        case lastMonth
        case thisYear
        case lastYear
        case someYear(Int) // where int is the year number, eg. 2022

        var description: String {
            switch self {
            case .today: return "Today"
            case .yesterday: return "Yesterday"
            case .dayOfWeek(let day): return day.description
            case .thisMonth: return "This Month"
            case .lastMonth: return "Last Month"
            case .thisYear: return "This Year"
            case .lastYear: return "Last Year"
            case .someYear(let year): return year.description
            }
        }

        enum DayOfWeek: Hashable {
            case monday, tuesday, wednesday, thursday, friday, saturday, sunday

            init(intValue: Int) {
                switch intValue {
                case 1: self = .monday
                case 2: self = .tuesday
                case 3: self = .wednesday
                case 4: self = .thursday
                case 5: self = .friday
                case 6: self = .saturday
                case 7: self = .sunday
                default: fatalError("Unidentified date")
                }
            }

            var description: String {
                switch self {
                case .monday: return "Monday"
                case .tuesday: return "Tuesday"
                case .wednesday: return "Wednesday"
                case .thursday: return "Thursday"
                case .friday: return "Friday"
                case .saturday: return "Saturday"
                case .sunday: return "Sunday"
                }
            }
        }
    }

    func getTimeBatch(for date: Date) -> TimeBatch {
        let calendar = Calendar.current
        let now = Date()

        if calendar.isDateInToday(date) {
            return .today
        } else if calendar.isDateInYesterday(date) {
            return .yesterday
        } else if let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: now), date >= oneWeekAgo && date < now,
                  let day = calendar.dateComponents([.weekday], from: date).weekday {
            return .dayOfWeek(.init(intValue: day))
        } else if calendar.isDate(date, equalTo: now, toGranularity: .month) {
            return .thisMonth
        } else if let lastMonthDate = calendar.date(byAdding: .month, value: -1, to: now), calendar.isDate(date, equalTo: lastMonthDate, toGranularity: .month) {
            return .lastMonth
        } else if calendar.isDate(date, equalTo: now, toGranularity: .year) {
            return .thisYear
        } else if let lastYearDate = calendar.date(byAdding: .year, value: -1, to: now), calendar.isDate(date, equalTo: lastYearDate, toGranularity: .year) {
            return .lastYear
        } else if let year = calendar.dateComponents([.year], from: date).year {
            return .someYear(year)
        }

        // Default fallback, should never be reached
        fatalError("Unrecognised time batch")
    }
}
