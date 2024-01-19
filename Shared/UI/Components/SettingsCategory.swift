//
//  SettingsCategory.swift
//  The GlassRoom
//
//  Created by Tristan Chay on 19/1/24.
//

import SwiftUI

struct SettingsCategory: View {
    
    var text: String
    var color: Color
    
    @ViewBuilder
    var symbol: (() -> (AnyView))
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 6)
                .frame(width: 28, height: 28)
                .foregroundColor(color)
                .overlay {
                    symbol()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                }
                .padding(.trailing, 5)
            Text(text)
        }
    }
}
