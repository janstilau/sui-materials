//
//  OverlaySheet.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/09/30.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import Foundation
import SwiftUI

struct OverlaySheet<Content: View>: View {

    @GestureState private var translation = CGPoint.zero

    private let isPresented: Binding<Bool>
    private let makeContent: () -> Content

    init(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content ) {
        self.isPresented = isPresented
        self.makeContent = content
    }

    var body: some View {
        VStack {
            Spacer()
            makeContent()
        }
        // 这里展示了, 平时的 PresentView 是怎么控制展示的.
        /*
         Summary

         Offset this view by the specified horizontal and vertical distances.
         Declaration

         func offset(x: CGFloat = 0, y: CGFloat = 0) -> some View
         Discussion

         Use offset(x:y:) to shift the displayed contents by the amount specified in the x and y parameters.
         The original dimensions of the view aren’t changed by offsetting the contents; in the example below the gray border drawn by this view surrounds the original position of the text:
         Text("Offset by passing horizontal & vertical distance")
             .border(Color.green)
             .offset(x: 20, y: 50)
             .border(Color.gray)
         Parameters

         x
         The horizontal distance to offset this view.
         y
         The vertical distance to offset this view.
         Returns

         A view that offsets this view by x and y.
         */
        .offset(y: (isPresented.wrappedValue ? 0 : UIScreen.main.bounds.height) + max(0, translation.y))
        .animation(.interpolatingSpring(stiffness: 70, damping: 12))
        .edgesIgnoringSafeArea(.bottom)
        .gesture(panelDraggingGesture)
    }

    var panelDraggingGesture: some Gesture {
        DragGesture()
            .updating($translation) { current, state, _ in
                state.y = current.translation.height
            }
            .onEnded { state in
                if state.translation.height > 250 {
                    self.isPresented.wrappedValue = false
                }
            }
    }
}

extension View {
    func overlaySheet<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View
    {
        overlay(
            OverlaySheet(isPresented: isPresented, content: content)
        )
    }
}
