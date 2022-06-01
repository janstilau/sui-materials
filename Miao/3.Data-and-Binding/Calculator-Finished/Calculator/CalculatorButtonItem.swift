//
//  CalculatorButtonItem.swift
//  Calculator
//
//  Created by 王 巍 on 2019/07/17.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import Foundation
import SwiftUI

// 这个 Model 中的状态, 一定是合法的.
// 是在 View 层, 手工输入进去的. 使用 Enum 的方式, 本身数据类型的限制, 就使得在逻辑上, 应该是没有非法状态的.
// 而配表的数据, 其实应该当做代码来看, 一定要经过 Debug 的过程, 可以说是程序员人工应该确保数据的正确. 
enum CalculatorButtonItem {
    case digit(Int) //
    case dot
    case op(Op)
    case command(Command)
}

extension CalculatorButtonItem {
    enum Op: String {
        case plus = "+"
        case minus = "-"
        case divide = "÷"
        case multiply = "×"
        case equal = "="
    }
    
    enum Command: String {
        case clear = "AC" // 清空
        case flip = "+/-" // 正负翻转
        case percent = "%" // 百分比计算
    }
}

extension CalculatorButtonItem {
    var title: String {
        switch self {
        case .digit(let value): return String(value)
        case .dot: return "."
        case .op(let op): return op.rawValue
        case .command(let command): return command.rawValue
        }
    }
    
    var size: CGSize {
        if case .digit(let value) = self, value == 0 {
            return CGSize(width: 88 * 2 + 8, height: 88)
        }
        return CGSize(width: 88, height: 88)
    }
    
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

extension CalculatorButtonItem: CustomStringConvertible {
    var description: String {
        switch self {
        case .digit(let num): return String(num)
        case .dot: return "."
        case .op(let op): return op.rawValue
        case .command(let command): return command.rawValue
        }
    }
}
