//
//  CalculatorButtonItem.swift
//  Calculator
//
//  Created by 王 巍 on 2019/07/17.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import Foundation
import SwiftUI

// 使用, Enum 当做数据盒子. 
enum CalculatorButtonItem {
    case digit(Int)
    case dot
    case op(Op)
    case command(Command)
}

extension CalculatorButtonItem {
    // 将, 各种状态, 通过 Enum 进行定义, 会让代码逻辑更加的清晰.
    enum Op: String {
        case plus = "+"
        case minus = "-"
        case divide = "÷"
        case multiply = "×"
        case equal = "="
    }
    
    enum Command: String {
        case clear = "AC"
        case flip = "+/-"
        case percent = "%"
    }
}

extension CalculatorButtonItem {
    // 该属性, 在 SwiftUI 的中用作了展示.
    var title: String {
        switch self {
        case .digit(let value): return String(value)
        case .dot: return "."
        case .op(let op): return op.rawValue
        case .command(let command): return command.rawValue
        }
    }
    
    // 所有 UI 相关的东西, 如果需要自我控制, 那么将这些逻辑封装到逻辑层.
    // 从这个意义上来看, View 中存储的, 其实会有很多的 ViewState 的值.
    var size: CGSize {
        if case .digit(let value) = self, value == 0 {
            return CGSize(width: 88 * 2 + 8, height: 88)
        }
        return CGSize(width: 88, height: 88)
    }
    
    // ViewState 相关的属性.
    var backgroundColorName: String {
        switch self {
        case .digit, .dot:
            return "digitBackground"
        case .op:
            return "operatorBackground"
        case .command:
            return "commandBackground"
        }
    }
    
    // ViewState 相关的属性.
    // 在 UI 中被用到了, 应该如何显示按钮的文字颜色.
    var foregroundColor: Color {
        switch self {
        case .command:
            return Color("commandForeground")
        default:
            return .white
        }
    }
}

extension CalculatorButtonItem: Hashable {}
