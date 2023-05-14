//
//  CourseAnnouncementsContentsListView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 14/5/23.
//

import SwiftUI
import GlassRoomAPI

struct CourseAnnouncementsContentsListView: View {
    @Binding var selectedPost: CoursePost?
    @ObservedObject var courseAnnouncementsManager: CourseAnnouncementsDataManager

    var body: some View {
        ZStack {
            if !courseAnnouncementsManager.courseAnnouncements.isEmpty {
                announcementsContent
            } else {
                VStack {
                    Text("No Announcements")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                }
                .frame(maxHeight: .infinity)
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack(alignment: .center) {
                Button {
                    courseAnnouncementsManager.loadList()
                    courseAnnouncementsManager.loadList(bypassCache: true)
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .buttonStyle(.plain)
                .contextMenu {
                    Button("Use Cache") {
                        courseAnnouncementsManager.loadList()
                    }
                }
                .offset(y: -1)

                if courseAnnouncementsManager.loading {
                    ProgressView()
                        .progressViewStyle(.linear)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                } else {
                    Spacer()
                }
            }
            .padding(.horizontal, 5)
            .frame(height: 25)
            .frame(maxWidth: .infinity)
            .background(.thinMaterial)
            .overlay(alignment: .top) {
                Divider()
            }
            .padding(.top, -7)
        }
    }

    var announcementsContent: some View {
        List {
            ForEach(courseAnnouncementsManager.courseAnnouncements, id: \.id) { announcement in
                CoursePostItem(announcement: announcement, selectedPost: $selectedPost)
            }
            
            if let token = courseAnnouncementsManager.nextPageToken {
                Button("Load next page") {
                    courseAnnouncementsManager.refreshList(nextPageToken: token)
                }
            }
        }
    }
}

func convertDate(_ dateString: String, _ dateStyle: Date.FormatStyle.DateStyle? = nil, _ timeStyle: Date.FormatStyle.TimeStyle? = nil) -> String {
    var returnDateString = ""

    if let date = dateString.iso8601withFractionalSeconds {
        guard let nonOptionalDateStyle = dateStyle else { return date.description }
        guard let nonOptionalTimeStyle = timeStyle else { return date.description }

        returnDateString = date.formatted(date: nonOptionalDateStyle, time: nonOptionalTimeStyle)
    }

    return returnDateString
}

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}

extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension Date {
    var iso8601withFractionalSeconds: String { return Formatter.iso8601withFractionalSeconds.string(from: self) }
}

extension String {
    var iso8601withFractionalSeconds: Date? { return Formatter.iso8601withFractionalSeconds.date(from: self) }
}