//
//  MainView.swift
//  The GlassRoom
//
//  Created by Tristan on 11/05/2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationSplitView {
            Text("Classes and Archives")
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
