//
//  TriStateToggle.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 3/6/23.
//

import SwiftUI

struct TriStateToggle: View {
    @Binding var toggleState: TriToggleState

    var body: some View {
        ZStack {
            switch toggleState {
            case .on:
                Color.green
            case .off:
                Color.red
            case .middle:
                Color.gray
            }
            HStack(spacing: 0) {
                if toggleState == .on || toggleState == .middle {
                    Color.white.opacity(0.001)
                        .onTapGesture {
                            print("Tap gesture: off")
                            toggleState = .off
                        }
                }
                if toggleState == .on {
                    Color.white.opacity(0.001)
                        .onTapGesture {
                            print("Tap gesture: middle")
                            toggleState = .middle
                        }
                }
                Circle()
                    .fill(.thickMaterial)
                    .shadow(radius: 3)
                    .padding(2)
                    .frame(width: 20, height: 20)
                if toggleState == .off {
                    Color.white.opacity(0.001)
                        .onTapGesture {
                            print("Tap gesture: middle")
                            toggleState = .middle
                        }
                }
                if toggleState == .off || toggleState == .middle {
                    Color.white.opacity(0.001)
                        .onTapGesture {
                            print("Tap gesture: on")
                            toggleState = .on
                        }
                }
            }
        }
        .cornerRadius(10)
        .frame(width: 50, height: 22)
        .animation(.default, value: toggleState)
    }
}

enum TriToggleState: Int {
    case on = 0
    case off = 1
    case middle = 2
}

struct TriStateToggle_Previews: PreviewProvider {
    static var previews: some View {
        TriStateToggle(toggleState: .constant(.middle))
    }
}
