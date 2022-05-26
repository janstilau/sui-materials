//
//  ContentView.swift
//  Calculator
//
//  Created by Wang Wei on 2019/06/17.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI
import Combine

/*
 从 Xcode 这样的预览设计, 可以决定了 Swift UI 里面的代码, 一定是竖长形的.
 各种使用了响应式框架的 MVVM 代码, 也都是竖长形的.
 */

let scale = UIScreen.main.bounds.width / 414

/*
 minimumScaleFactor
 
 Sets the minimum amount that text in this view scales down to fit in the available space.
 Declaration
 
 func minimumScaleFactor(_ factor: CGFloat) -> some View
 Discussion
 
 Use the minimumScaleFactor(_:) modifier if the text you place in a view doesn’t fit and it’s okay if the text shrinks to accommodate. For example, a label with a minimum scale factor of 0.5 draws its text in a font size as small as half of the actual font if needed.
 In the example below, the HStack contains a Text label with a line limit of 1, that is next to a TextField. To allow the label to fit into the available space, the minimumScaleFactor(_:) modifier shrinks the text as needed to fit into the available space.
 HStack {
 Text("This is a long label that will be scaled to fit:")
 .lineLimit(1)
 .minimumScaleFactor(0.5)
 TextField("My Long Text Field", text: $myTextField)
 }
 Parameters
 
 factor
 A fraction between 0 and 1 (inclusive) you use to specify the minimum amount of text scaling that this view permits.
 Returns
 
 A view that limits the amount of text downscaling.
 */

/*
 Frame
 
 Summary
 Positions this view within an invisible frame having the specified size constraints.
 
 Declaration
 
 func frame(minWidth: CGFloat? = nil, idealWidth: CGFloat? = nil, maxWidth: CGFloat? = nil, minHeight: CGFloat? = nil, idealHeight: CGFloat? = nil, maxHeight: CGFloat? = nil, alignment: Alignment = .center) -> some View
 Discussion
 
 Always specify at least one size characteristic when calling this method. Pass nil or leave out a characteristic to indicate that the frame should adopt this view’s sizing behavior, constrained by the other non-nil arguments.
 The size proposed to this view is the size proposed to the frame, limited by any constraints specified, and with any ideal dimensions specified replacing any corresponding unspecified dimensions in the proposal.
 If no minimum or maximum constraint is specified in a given dimension, the frame adopts the sizing behavior of its child in that dimension. If both constraints are specified in a dimension, the frame unconditionally adopts the size proposed for it, clamped to the constraints. Otherwise, the size of the frame in either dimension is:
 If a minimum constraint is specified and the size proposed for the frame by the parent is less than the size of this view, the proposed size, clamped to that minimum.
 If a maximum constraint is specified and the size proposed for the frame by the parent is greater than the size of this view, the proposed size, clamped to that maximum.
 Otherwise, the size of this view.
 Parameters
 
 minWidth
 The minimum width of the resulting frame.
 idealWidth
 The ideal width of the resulting frame.
 maxWidth
 The maximum width of the resulting frame.
 minHeight
 The minimum height of the resulting frame.
 idealHeight
 The ideal height of the resulting frame.
 maxHeight
 The maximum height of the resulting frame.
 alignment
 The alignment of this view inside the resulting frame. Note that most alignment values have no apparent effect when the size of the frame happens to match that of this view.
 Returns
 
 A view with flexible dimensions given by the call’s non-nil parameters.
 */
struct ContentView : View {
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Text("0")
                .font(.system(size: 76))
            //                .minimumScaleFactor(0.5)
                .padding(.trailing, 24 * scale)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                .border(Color.red)
            
            CalculatorButtonPad()
                .padding(.bottom)
        }
    }
}

struct CalculatorButton : View {
    let fontSize: CGFloat = 38
    let title: String
    let size: CGSize
    let backgroundColorName: String
    let foregroundColor: Color
    let action: () -> Void
    
    var body: some View {
        // 符合同样方法签名的闭包, 直接进行传入就好了.
        Button(action: action) {
            Text(title)
                .font(.system(size: fontSize * scale))
                .foregroundColor(foregroundColor)
            // Size 的信息, 是用到了 FrameModifier 中.
                .frame(width: size.width * scale, height: size.height * scale)
                .background(Color(backgroundColorName))
                .cornerRadius(size.width * scale / 2)
        }
    }
}

struct CalculatorButtonRow : View {
    // View 的 Model, 应该是和 View 紧密相关的.
    let row: [CalculatorButtonItem]
    
    var body: some View {
        HStack {
            ForEach(row, id: \.self) { item in
                // 参数过多的时候, 这种写法是 Swfit 的标准.
                CalculatorButton(
                    title: item.title,
                    size: item.size,
                    backgroundColorName: item.backgroundColorName,
                    foregroundColor: item.foregroundColor)
                {
                    print("Button: \(item.title)")
                }
            }
        }
    }
}

struct CalculatorButtonPad: View {
    // 使用 Model, 来控制 UI, 这是一个决定不会错的思路.
    // 直接, 把数据放到了 CalculatorButtonPad 的内部了.
    let pad: [[CalculatorButtonItem]] = [
        [.command(.clear), .command(.flip),
         .command(.percent), .op(.divide)],
        
        [.digit(7), .digit(8), .digit(9), .op(.multiply)],
        
        [.digit(4), .digit(5), .digit(6), .op(.minus)],
        
        [.digit(1), .digit(2), .digit(3), .op(.plus)],
        
        [.digit(0), .dot, .op(.equal)]
    ]
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(pad, id: \.self) { row in
                CalculatorButtonRow(row: row)
            }
        }
    }
}

struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView().previewDevice("iPhone SE")
            ContentView().previewDevice("iPad Air 2")
        }
    }
}
