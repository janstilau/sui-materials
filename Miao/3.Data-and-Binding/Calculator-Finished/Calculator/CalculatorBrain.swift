//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 王 巍 on 2019/07/19.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import Foundation

/*
 CalculatorBrain 这个类, 是主要的计算器逻辑类.
 但是, 存储是 ViewModel 中做的.
 这是一个工具类.
 */
/*
 根据当前的值, 以及传递过来的 Item 的值, 计算出新的状态值. 这符合 Reduce 的思想.
 */
enum CalculatorBrain {
    case left(String) // 正在输入左操作数
    case leftOp(left: String, op: CalculatorButtonItem.Op) // 输入了左操作数, 正在输入操作符.
    case leftOpRight(left: String, op: CalculatorButtonItem.Op, right: String) // 输入了左操作数, 操作符, 正在输入右操作数.
    case error
    
    /*
     这个类, 最最重要的方法. 根据用户的输入, 更新当前状态机的内容.
     整个更新的逻辑, 是放到了这个类里面, 在 ViewModel 里面, 并不用关心计算器的逻辑.
     
     ViewModel 本质上来说, 是 Controller 层的东西. 而 MVC 的问题, 就是 Controller 里面的逻辑太过于繁琐和复杂.
     使用业务逻辑类, 或者说, Model 类将相关的逻辑进行封装, 能够大大简化 Controller 层的逻辑. 这在 MVVM 这种架构里面, 也是同样的思路.
     */
    @discardableResult
    func apply(item: CalculatorButtonItem) -> CalculatorBrain {
        // 各种 Apply 操作的逻辑, 除了和用户点击的按钮相关, 更和当前的 Briain 的状态相关.
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
    
    // ViewState 相关的计算属性.
    // 根据当前自己所处的状态, 计算出应该显示到上方 Panel 中的内容.
    // Swfit UI 中, 是直接根据 Model 的 output, 进行上方面板的显示的.
    var output: String {
        let result: String
        // 具体的实现, 就是根据当前的 case 值, 抽取应该显示的内容.
        // Enum 数据容器的作用, 在这里体现了出来了.
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

// 真正的 Apply, 是一个 Dispatch 函数. 根据 Item 的种类不同, 来进行不同的 Apply 函数的调用.
extension CalculatorBrain {
    private func apply(num: Int) -> CalculatorBrain {
        switch self {
        case .left(let left):
            // 左操作数输入状态, 碰到了数字, 归到左操作数中.
            return .left(left.apply(num: num))
        case .leftOp(let left, let op):
            // 操作符输入结束, 碰到了数字, 归到右操作数中.
            return .leftOpRight(left: left, op: op, right: "0".apply(num: num))
        case .leftOpRight(let left, let op, let right):
            // 右操作数输入状态, 碰到了数字, 归到右操作数中.
            return .leftOpRight(left: left, op: op, right: right.apply(num: num))
        case .error:
            // 当前错误状态, 碰到了数字, 认为开启新的计算流程, 归到左操作数中.
            return .left("0".apply(num: num))
        }
    }
    
    private func applyDot() -> CalculatorBrain {
        switch self {
        case .left(let left):
            // 做操作数输入状态, 碰到小数点, 将小数点, 合并到左操作数中.
            return .left(left.applyDot())
        case .leftOp(let left, let op):
            // 操作符输入完毕状态, 碰到了小数点, 将小数点, 归到右操作数中.
            return .leftOpRight(left: left, op: op, right: "0".applyDot())
        case .leftOpRight(let left, let op, let right):
            // 右操作数输入状态, 碰到了小数点, 将小数点, 归到右操作数中.
            return .leftOpRight(left: left, op: op, right: right.applyDot())
        case .error:
            // 当前错误状态, 碰到了小数点, 将小数点, 归到左操作数中.
            return .left("0".applyDot())
        }
    }
    
    private func apply(op: CalculatorButtonItem.Op) -> CalculatorBrain {
        switch self {
        case .left(let left):
            switch op {
                // 左操作数输入状态, 碰到了操作符, 进入到操作符输入完毕状态.
                // 所以, 实际上, 这里并没有做计算.
            case .plus, .minus, .multiply, .divide:
                return .leftOp(left: left, op: op)
                // 左操作数输入状态, 碰到了==操作符, 还是在左操作符输入状态.
                // 这是一个很好的设计, 保持了后续的操作流程.
            case .equal:
                return self
            }
        case .leftOp(let left, let currentOp):
            switch op {
            case .plus, .minus, .multiply, .divide:
                // 操作符输入完毕状态, 碰到了操作符, 其实是修改输入的操作符.
                // 这是一个很好的设计.
                return .leftOp(left: left, op: op)
            case .equal:
                // 这可能是一个通用逻辑, 就是前操作符赋值成为后操作数, 来做运算. 等号的方便用法????
                if let result = currentOp.calculate(l: left, r: left) {
                    return .leftOp(left: result, op: currentOp)
                } else {
                    return .error
                }
            }
        case .leftOpRight(let left, let currentOp, let right):
            switch op {
                // 在这种场景下, 再次点击 Operation 的按钮, 就需要将上一个阶段的数据进行计算融合了.
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
    // 数字和数字的拼接工作.
    // 在小函数里面, 将各种特殊 Case 进行处理, 在高层逻辑里面, 使用起来就会很方便.
    func apply(num: Int) -> String {
        return self == "0" ? "\(num)" : "\(self)\(num)"
    }
    
    // 数字和小数点的拼接工作.
    func applyDot() -> String {
        // 如果, 已经是包含了小数点, 那么就不做处理了.
        // 这是一个正确的操作. 相比较于报错, 认为这是用户的无意间的错误行为, 是更加友好的设计思路.
        return containsDot ? self : "\(self)."
    }
    
    var containsDot: Bool {
        return contains(".")
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
    
    var startWithNegative: Bool {
        return starts(with: "-")
    }
    
    func percentaged() -> String {
        return String(Double(self)! / 100)
    }
}

extension CalculatorButtonItem.Op {
    // 将四则运算的相关逻辑, 放到了 Operation 类里面了.
    // 非常好的设计. 完美的解决了, 函数应该在哪个类中定义的问题.
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
