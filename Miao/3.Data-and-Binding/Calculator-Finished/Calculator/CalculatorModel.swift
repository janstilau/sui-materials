//
//  CalculatorHistory.swift
//  Calculator
//
//  Created by 王 巍 on 2019/07/20.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI
import Combine

/*
 ObservableObject 中, 如果有 @Published
 */
class CalculatorModel: ObservableObject {
    
    @Published var brainLogic: CalculatorBrain = .left("0")
    @Published var history: [CalculatorButtonItem] = []
    
    var temporaryKept: [CalculatorButtonItem] = []
    
    func apply(_ item: CalculatorButtonItem) {
        // Brain 记录了当前的输入状态.
        // 并且, 封装了根据记录状态和输入, 计算出新的状态的能力.
        // Brain, 是一个 Enum 对象, 一个值语义的对象. 所以每次都是全量的更新. 而这种更新方式, 使得 @Published 生效.
        brainLogic = brainLogic.apply(item: item)
        history.append(item)
        
        // 有了新的操作, 历史记录中后续还没有表现出来的操作, 也就废弃了.
        // 然后, 让 Index 到达最后一步.
        temporaryKept.removeAll()
        slidingIndex = Float(totalCount)
    }
    
    var historyDetail: String {
        //把所有的操作符, 进行拼接的过程.
        history.map { $0.description }.joined()
    }
    
    func keepHistory(upTo index: Int) {
        precondition(index <= totalCount, "Out of index.")
        
        let total = history + temporaryKept
        
        // 通过 Slider 的值, 对
        history = Array(total[..<index])
        temporaryKept = Array(total[index...])
        
        brainLogic = history.reduce(CalculatorBrain.left("0")) {
            result, item in
            // brain 的状态, 是从头到尾进行了一次计算模拟得到的.
            // 所以, 这里感觉会有一些性能损失.
            result.apply(item: item)
        }
    }
    
    // Total Count 是所有的值. 显示的, 和存储的.
    var totalCount: Int {
        history.count + temporaryKept.count
    }
    
    var slidingIndex: Float = 0 {
        didSet {
            keepHistory(upTo: Int(slidingIndex))
        }
    }
}
