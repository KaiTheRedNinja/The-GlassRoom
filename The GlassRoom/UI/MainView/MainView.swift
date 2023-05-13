//
//  MainView.swift
//  The GlassRoom
//
//  Created by Tristan on 11/05/2023.
//

import SwiftUI
import GlassRoomAPI

struct MainView: View {
    var body: some View {
        NavigationSplitView {
            VStack {
                Text("Classes and Archives")
            }
            Button("Log Out") {
                UserAuthModel.shared.signOut()
            }
            Button("Test get") {
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
                    case .failure(let failure):
                        print("Failure: \(failure.localizedDescription)")
                    }
                }
            }
        } content: {
            List {
                ForEach(1...7, id: \.self) { _ in
                    PostItemView
                }
            }
        } detail: {
            Text("No Post Selected")
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
