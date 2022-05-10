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

struct ContentView : View {
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Text("0")
                .font(.system(size: 76))
                .minimumScaleFactor(0.5)
                .padding(.trailing, 24 * scale)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
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
    let row: [CalculatorButtonItem]
    
    var body: some View {
        HStack {
            ForEach(row, id: \.self) { item in
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

// 如果, 不在 SwiftUI 的 View 文件里面, 编写下面的代码, 右侧是不会出现 Canvas 面板的.
//struct ContentView_Previews : PreviewProvider {
//    static var previews: some View {
//        Group {
//            ContentView()
////            ContentView().previewDevice("iPhone SE")
////            ContentView().previewDevice("iPad Air 2")
//        }
//    }
//}
