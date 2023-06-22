//
//  SegmentedControl.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 14/5/23.
//

import SwiftUI

/// A view that creates a segmented control from an array of text labels.
struct SegmentedControl: View {
    private var options: [String]
    private var prominent: Bool

    @Binding
    private var preselectedIndex: Int
    var getSymbolForLabel: (String) -> String

    /// A view that creates a segmented control from an array of text labels.
    /// - Parameters:
    ///   - selection: The index of the current selected item.
    ///   - options: the options to display as an array of strings.
    ///   - prominent: A Bool indicating whether to use a prominent appearance instead
    ///   of the muted selection color. Defaults to `false`.
    init(
        _ selection: Binding<Int>,
        options: [String],
        prominent: Bool = false,
        getSymbolForLabel: @escaping (String) -> String
    ) {
        self._preselectedIndex = selection
        self.options = options
        self.prominent = prominent
        self.getSymbolForLabel = getSymbolForLabel
    }
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(options.indices, id: \.self) { index in
                SegmentedControlItem(
                    label: options[index],
                    image: getSymbolForLabel(options[index]),
                    active: preselectedIndex == index,
                    action: {
                        preselectedIndex = index
                    },
                    prominent: prominent
                )

            }
        }
        .frame(height: 20)
    }
}

struct SegmentedControlItem: View {
    #if os(macOS)
    private let color: Color = Color(nsColor: .selectedControlColor)
    #else
    private let color: Color = Color(uiColor: .secondarySystemFill)
    #endif
    let label: String
    let image: String
    let active: Bool
    let action: () -> Void
    let prominent: Bool

    @Environment(\.colorScheme)
    private var colorScheme

    #if os(macOS)
    @Environment(\.controlActiveState)
    private var activeState
    #endif

    @State
    var isHovering: Bool = false

    @State
    var isPressing: Bool = false

    func isActive() -> Bool {
        #if os(macOS)
        return activeState != .inactive
        #else
        return true
        #endif
    }

    var body: some View {
        VStack {
            Image(systemName: image)
        }
        .font(.subheadline)
        .foregroundColor(textColor)
        .opacity(textOpacity)
        .frame(height: 20)
        .padding(.horizontal, 7.5)
        .background(
            background
        )
        .cornerRadius(5)
        .onTapGesture {
            action()
        }
        .onHover { hover in
            isHovering = hover
        }
        .pressAction {
            isPressing = true
        } onRelease: {
            isPressing = false
        }
        .help(label)
    }

    private var textColor: Color {
        if prominent {
            return active
            ? .white
            : .primary
        } else {
            return active
            ? colorScheme == .dark ? .white : .accentColor
            : .primary
        }
    }

    private var textOpacity: Double {
        if prominent {
            return isActive() ? 1 : active ? 1 : 0.3
        } else {
            return isActive() ? 1 : active ? 0.5 : 0.3
        }
    }

    @ViewBuilder
    private var background: some View {
        if prominent {
            if active {
                Color.accentColor.opacity(isActive() ? 1 : 0.5)
            } else {
                Color(colorScheme == .dark ? .white : .black)
                    .opacity(isPressing ? 0.10 : isHovering ? 0.05 : 0)
            }
        } else {
            if active {
                color.opacity(isPressing ? 1 : isActive() ? 0.75 : 0.5)
            } else {
                Color(colorScheme == .dark ? .white : .black)
                    .opacity(isPressing ? 0.10 : isHovering ? 0.05 : 0)
            }
        }
    }
}

struct PressActions: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void

    init(onPress: @escaping () -> Void, onRelease: @escaping () -> Void) {
        self.onPress = onPress
        self.onRelease = onRelease
    }

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        onPress()
                    })
                    .onEnded({ _ in
                        onRelease()
                    })
            )
    }
}

extension View {

    /// A custom view modifier for press actions with callbacks for `onPress` and `onRelease`.
    /// - Parameters:
    ///   - onPress: Action to perform once the view is pressed.
    ///   - onRelease: Action to perform once the view press is released.
    /// - Returns: some View
    func pressAction(onPress: @escaping (() -> Void), onRelease: @escaping (() -> Void)) -> some View {
        modifier(PressActions(onPress: {
            onPress()
        }, onRelease: {
            onRelease()
        }))
    }
}
