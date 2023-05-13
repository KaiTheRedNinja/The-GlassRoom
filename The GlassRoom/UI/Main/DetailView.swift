//
//  DetailView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 13/5/23.
//

import SwiftUI
import GlassRoomAPI

struct DetailView: View {
    @Binding var selectedCourse: Course?
//    @Binding var selectedPost:

    var body: some View {
        VStack {
            Text("Course: \(selectedCourse?.name ?? "nothing")")
            Text("No Post Selected")
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(selectedCourse: .constant(nil))
    }
}
