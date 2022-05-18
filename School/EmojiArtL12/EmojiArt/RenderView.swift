//
//  RenderView.swift
//  EmojiArt
//
//  Created by JustinLau on 2022/5/18.
//

import SwiftUI

/*
 Fixes this view at its ideal size.
 Declaration

 func fixedSize() -> some View
 Discussion

 During the layout of the view hierarchy, each view proposes a size to each child view it contains. If the child view doesn’t need a fixed size it can accept and conform to the size offered by the parent.
 For example, a Text view placed in an explicitly sized frame wraps and truncates its string to remain within its parent’s bounds:
 Text("A single line of text, too long to fit in a box.")
     .frame(width: 200, height: 200)
     .border(Color.gray)
 The fixedSize() modifier can be used to create a view that maintains the ideal size of its children both dimensions:
 Text("A single line of text, too long to fit in a box.")
     .fixedSize()
     .frame(width: 200, height: 200)
     .border(Color.gray)
 This can result in the view exceeding the parent’s bounds, which may or may not be the effect you want.
 You can think of fixedSize() as the creation of a counter proposal to the view size proposed to a view by its parent. The ideal size of a view, and the specific effects of fixedSize() depends on the particular view and how you have configured it.
 To create a view that fixes the view’s size in either the horizontal or vertical dimensions, see fixedSize(horizontal:vertical:).
 Returns

 A view that fixes this view at its ideal size.
 */

struct RenderView: View {
    var body: some View {
        Text("This long text string is clipped")
            .fixedSize()
            .frame(width: 175, height: 100)
//            .clipped()
            .border(Color.gray)
    }
}

struct RenderView_Previews: PreviewProvider {
    static var previews: some View {
        RenderView()
    }
}
