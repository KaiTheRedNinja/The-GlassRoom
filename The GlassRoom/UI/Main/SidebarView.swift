//
//  SidebarView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 13/5/23.
//

import SwiftUI
import GlassRoomAPI

struct SidebarView: View {
    @Binding var selection: Course?

    @State var courses: [Course] = []

    var body: some View {
        List {
            ForEach(0..<courses.count, id: \.self) { index in
                let course = courses[index]
                VStack(alignment: .leading) {
                    Text(course.name)
                    if let description = course.description {
                        Text(description)
                    }
                }
            }
        }
        .onAppear {
            GlassRoomAPI.GRCourses.list(
                params: VoidStringCodable(),
                query: .init(studentId: nil,
                             teacherId: nil,
                             courseStates: nil,
                             pageSize: nil,
                             pageToken: nil),
                data: VoidStringCodable()
            ) { response in
                switch response {
                case .success(let success):
                    print("Success! \(success)")
                    self.courses = success.courses
                case .failure(let failure):
                    print("Failure: \(failure.localizedDescription)")
                }
            }
        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(selection: .constant(nil))
    }
}
