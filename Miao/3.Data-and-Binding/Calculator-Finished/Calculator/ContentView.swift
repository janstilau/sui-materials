//
//  ContentView.swift
//  Calculator
//
//  Created by Wang Wei on 2019/06/17.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI
import Combine

// 这就是一个 Swift 文件, 可以定义各种需要使用的常量.
let scale = UIScreen.main.bounds.width / 414

struct ContentView : View {
    
    @EnvironmentObject var calculateViewModel: CalculatorModel
    
    @State private var editingHistory = false
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            // 在 View 中, 其实是已经预埋了按钮点击之后的流程了.
            // 更改 Model, 来触发这个流程.
            // 一切, 都建立在对于 Model 的修改之上.
            // 这种, 使用 project 的值应该是一个非常非常通用的设置了.
            Button("操作履历: \(calculateViewModel.history.count)") {
                self.editingHistory = true
            }.sheet(isPresented: self.$editingHistory) {
                HistoryView(model: self.calculateViewModel)
            }
            
            // 直接是使用了 ViewModel 的属性的计算方法来获取 UI 展示.
            Text(calculateViewModel.brainLogic.output)
                .font(.system(size: 76))
                .minimumScaleFactor(0.5)
                .padding(.horizontal, 24 * scale)
                .lineLimit(1)
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    alignment: .trailing)
            
            // 使用, @EnvironmentObject 这种方式, 不用传输值了.
            CalculatorButtonPad()
                .padding(.bottom)
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

struct CalculatorButtonRow : View {
    let row: [CalculatorButtonItem]
    @EnvironmentObject var model: CalculatorModel
    var body: some View {
        HStack {
            ForEach(row, id: \.self) { item in
                CalculatorButton(
                    title: item.title,
                    size: item.size,
                    backgroundColorName: item.backgroundColorName,
                    foregroundColor: item.foregroundColor)
                {
                    // 在 UI 文件里面, 将 ViewAction 确定.
                    // 因为 UI 里面, 无法进行数据更改, 所以就是触发 ModelAction. Model 改变之后, 再次触发 View 的更改
                    self.model.apply(item)
                }
            }
        }
    }
}

// 对于这种小 View, 是把所有的属性暴露出来.
// 因为, 这些属性的配置过程, 是在组件的内部, 不会直接暴露给用户.
struct CalculatorButton : View {
    // 各种, 相关的数据, 需要在构造方法中传递过来.
    // 并且, 因为 SwiftUI 里面的都是 Struct 类型的, 所以, 自动的进行了 memberWise 构造方法的声明.
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
                .frame(width: size.width * scale, height: size.height * scale)
                .background(Color(backgroundColorName))
                .cornerRadius(size.width * scale / 2)
        }
    }
}

// 非常简单的一些声明式的语句, 就能够显示整个 View 了
struct HistoryView: View {
    // @ObservedObject 的标识, 标识存储位置不在这里.
    @ObservedObject var model: CalculatorModel
    var body: some View {
        VStack {
            if model.totalCount == 0 {
                Text("没有履历")
            } else {
                HStack {
                    Text("履历").font(.headline)
                    Text("\(model.historyDetail)").lineLimit(nil)
                }
                HStack {
                    Text("显示").font(.headline)
                    Text("\(model.brainLogic.output)")
                }
                // Slider 的修改, 会引起 ViewModel 的修改.
                // 而 ViewModel 的修改, 会导致
                Slider(value: $model.slidingIndex,
                       in: 0...Float(model.totalCount),
                       step: 1)
            }
        }.padding()
    }
}


//struct ContentView_Previews : PreviewProvider {
//    static var previews: some View {
//        Group {
//            ContentView()
//            ContentView().previewDevice("iPhone SE")
//            ContentView().previewDevice("iPad Air 2")
//        }
//    }
//}
