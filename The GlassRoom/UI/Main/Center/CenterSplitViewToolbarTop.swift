//
//  CenterSplitViewToolbarTop.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 14/5/23.
//

import SwiftUI

struct CenterSplitViewToolbarTop: View {
    typealias CourseDisplayOption = CenterSplitView.CourseDisplayOption
    @Binding var currentPage: CourseDisplayOption

    var body: some View {
        HStack(alignment: .center) {
            SegmentedControl(.init(get: {
                switch currentPage {
                case .announcements: return 0
                case .courseWork: return 1
                case .allPosts: return 2
                }
            }, set: { newValue in
                currentPage = .allCases[newValue]
            }), options: CourseDisplayOption.allCases.map({ $0.rawValue }))
        }
        .padding(.horizontal, 5)
        .frame(height: 25)
        .frame(maxWidth: .infinity)
        .background(.thinMaterial)
        .overlay(alignment: .bottom) {
            Divider()
                .offset(y: 1)
        }
        .padding(.bottom, -7)
    }
}