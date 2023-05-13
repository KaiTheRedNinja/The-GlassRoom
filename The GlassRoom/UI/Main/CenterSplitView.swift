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
//    @Binding var selectedPost:

    var body: some View {
        VStack {
            Text("Posts for \(selectedCourse?.name ?? "nothing")")
            Button("Log Out") {
                UserAuthModel.shared.signOut()
            }
        }
    }
}

struct CenterSplitView_Previews: PreviewProvider {
    static var previews: some View {
        CenterSplitView(selectedCourse: .constant(nil))
    }
}
