//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 王 巍 on 2019/07/19.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import Foundation

// 这是一个状态类.
enum CalculatorBrain {
    case left(String)
    case leftOp(left: String, op: CalculatorButtonItem.Op)
    // 存储了状态, 但是还没有计算. 因为 right 的值, 可能还在不断的拼接新的输入.
    // 只有到了应该触发的时候, 比如输入了 =, 或者 下一个操作符的时候, 才会将 leftOpRight 的值进行计算, 然后将状态变为 leftOp.
    case leftOpRight(left: String, op: CalculatorButtonItem.Op, right: String)
    case error
    
    /*
     CalculatorButtonItem 是计算器视图的每个 View 的 Model 类型.
     使用 Enum 的方式, 使得状态管理更加的清晰, Model 中不会有非法状态的存在.
     */
    @discardableResult
    func apply(item: CalculatorButtonItem) -> CalculatorBrain {
        switch item {
        case .digit(let num):
            return apply(num: num)
        case .dot:
            return applyDot()
        case .op(let op):
            return apply(op: op)
        case .command(let command):
            return apply(command: command)
        }
    }
    
    // ViewState 相关的计算属性. 是这个类存在的根本.
    // 数据修改了之后, 需要暴露给外界, 这个类才有意义. 在 SwiftUI 中, 就是给 View 提供显示数据.
    var output: String {
        let result: String
        switch self {
        case .left(let left): result = left
        case .leftOp(let left, _): result = left
        case .leftOpRight(_, _, let right): result = right
        case .error: return "Error"
        }
        guard let value = Double(result) else {
            return "Error"
        }
        return formatter.string(from: value as NSNumber)!
    }
}

extension CalculatorBrain {
    private func apply(num: Int) -> CalculatorBrain {
        switch self {
        case .left(let left):
            return .left(left.apply(num: num))
        case .leftOp(let left, let op):
            return .leftOpRight(left: left, op: op, right: "0".apply(num: num))
        case .leftOpRight(let left, let op, let right):
            return .leftOpRight(left: left, op: op, right: right.apply(num: num))
        case .error:
            // 如果当前的状态是错误状态, 那么新的输入, 会自动的开启下一个计算流程.
            return .left("0".apply(num: num))
        }
    }
    
    private func applyDot() -> CalculatorBrain {
        switch self {
        case .left(let left):
            return .left(left.applyDot())
        case .leftOp(let left, let op):
            return .leftOpRight(left: left, op: op, right: "0".applyDot())
        case .leftOpRight(let left, let op, let right):
            return .leftOpRight(left: left, op: op, right: right.applyDot())
        case .error:
            return .left("0".applyDot())
        }
    }
    
    private func apply(op: CalculatorButtonItem.Op) -> CalculatorBrain {
        switch self {
        case .left(let left):
            switch op {
            case .plus, .minus, .multiply, .divide:
                return .leftOp(left: left, op: op)
            case .equal:
                return self
            }
        case .leftOp(let left, let currentOp):
            switch op {
            case .plus, .minus, .multiply, .divide:
                return .leftOp(left: left, op: op)
            case .equal:
                // 如果, 是 1+=这种情形, 那么默认是将 1+1=2 的计算, 也就是第一个操作数, 进行了重用处理.
                if let result = currentOp.calculate(l: left, r: left) {
                    return .leftOp(left: result, op: currentOp)
                } else {
                    return .error
                }
            }
        case .leftOpRight(let left, let currentOp, let right):
            switch op {
            case .plus, .minus, .multiply, .divide:
                if let result = currentOp.calculate(l: left, r: right) {
                    return .leftOp(left: result, op: op)
                } else {
                    return .error
                }
            case .equal:
                if let result = currentOp.calculate(l: left, r: right) {
                    return .left(result)
                } else {
                    return .error
                }
            }
        case .error:
            return self
        }
    }
    
    private func apply(command: CalculatorButtonItem.Command) -> CalculatorBrain {
        switch command {
        case .clear:
            return .left("0")
        case .flip:
            switch self {
            case .left(let left):
                return .left(left.flipped())
            case .leftOp(let left, let op):
                return .leftOpRight(left: left, op: op, right: "-0")
            case .leftOpRight(left: let left, let op, let right):
                return .leftOpRight(left: left, op: op, right: right.flipped())
            case .error:
                return .left("-0")
            }
        case .percent:
            switch self {
            case .left(let left):
                return .left(left.percentaged())
            case .leftOp:
                return self
            case .leftOpRight(left: let left, let op, let right):
                return .leftOpRight(left: left, op: op, right: right.percentaged())
            case .error:
                return .left("-0")
            }
        }
    }
}

// 这是一个全局量
var formatter: NumberFormatter = {
    let f = NumberFormatter()
    f.minimumFractionDigits = 0
    f.maximumFractionDigits = 8
    f.numberStyle = .decimal
    return f
}()

// 各种相关的值的计算, 是放到了相关的数据类型里面了.
// 并没有把逻辑, 统一的放到了 CalculatorBrain 里面. 这样, 逻辑的存储位置更加的合理.
// 如果, extensnion 前面有着范围限定符, 那么是更加清晰的代码布局方式.
extension String {
    var containsDot: Bool {
        return contains(".")
    }
    
    var startWithNegative: Bool {
        return starts(with: "-")
    }
    
    // 数字和数字的拼接工作.
    // 在小函数里面, 将各种特殊 Case 进行处理, 在高层逻辑里面, 使用起来就会很方便.
    func apply(num: Int) -> String {
        return self == "0" ? "\(num)" : "\(self)\(num)"
    }
    
    // 数字和小数点的拼接工作.
    func applyDot() -> String {
        return containsDot ? self : "\(self)."
    }
    
    func flipped() -> String {
        if startWithNegative {
            var s = self
            s.removeFirst()
            return s
        } else {
            return "-\(self)"
        }
    }
    
    func percentaged() -> String {
        return String(Double(self)! / 100)
    }
}

extension CalculatorButtonItem.Op {
    func calculate(l: String, r: String) -> String? {
        guard let left = Double(l),
              let right = Double(r) else {
                  return nil
              }
        
        let result: Double?
        switch self {
        case .plus: result = left + right
        case .minus: result = left - right
        case .multiply: result = left * right
        case .divide: result = right == 0 ? nil : left / right
        case .equal: fatalError()
        }
        return result.map { String($0) }
    }
}
