//
//  MainView.swift
//  The GlassRoom
//
//  Created by Tristan on 11/05/2023.
//

import SwiftUI
import GlassRoomAPI

struct MainView: View {
    @State var courses: [Course] = []

    var body: some View {
        NavigationSplitView {
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
        } content: {
            VStack {
                Text("Posts")
                Button("Log Out") {
                    UserAuthModel.shared.signOut()
                }
            }
//            List {
//                ForEach(1...7, id: \.self) { _ in
//                    PostItemView
//                }
//            }
        } detail: {
            VStack {
                Text("No Post Selected")
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
    
    var PostItemView: some View {
        VStack(alignment: .leading) {
            Text("Assignment Title")
                .font(.title3)
                .fontWeight(.bold)

            Label("\(Date.now)", systemImage: "timer")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
