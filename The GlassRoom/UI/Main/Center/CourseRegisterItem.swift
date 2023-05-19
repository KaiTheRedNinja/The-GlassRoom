//
//  CourseRegisterItem.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 19/5/23.
//

import SwiftUI
import GlassRoomTypes

struct CourseRegisterItem: View {
    var userProfile: UserProfile

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: "https:" + (userProfile.photoUrl ?? ""))) { image in
                image
                    .resizable()
            } placeholder: {
                Image(systemName: "person.circle")
                    .resizable()
            }
            .mask({ Circle() })
            .frame(width: 30, height: 30)

            VStack(alignment: .leading) {
                HStack {
                    if let verified = userProfile.verifiedTeacher, verified {
                        Image(systemName: "checkmark.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 8, height: 8)
                    }
                    Text(userProfile.name.fullName)
                }
                if let email = userProfile.emailAddress {
                    Text(email)
                        .font(.caption)
                }
            }
        }
    }
}
