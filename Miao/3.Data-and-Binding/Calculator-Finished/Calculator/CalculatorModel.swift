//
//  CalculatorHistory.swift
//  Calculator
//
//  Created by 王 巍 on 2019/07/20.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI
import Combine

class CalculatorModel: ObservableObject {
    
    @Published var brain: CalculatorBrain = .left("0")
    @Published var history: [CalculatorButtonItem] = []
    
    var temporaryKept: [CalculatorButtonItem] = []
    
    func apply(_ item: CalculatorButtonItem) {
        // Brain 记录了当前的输入状态.
        // 并且, 封装了根据记录状态和输入, 计算出新的状态的能力.
        // Brain, 是一个 Enum 对象, 一个值语义的对象. 所以每次都是全量的更新. 而这种更新方式, 使得 @Published 生效.
        brain = brain.apply(item: item)
        history.append(item)
        
        temporaryKept.removeAll()
        slidingIndex = Float(totalCount)
    }
    
    var historyDetail: String {
        history.map { $0.description }.joined()
    }
    
    func keepHistory(upTo index: Int) {
        precondition(index <= totalCount, "Out of index.")
        
        let total = history + temporaryKept
        
        history = Array(total[..<index])
        temporaryKept = Array(total[index...])
        
        brain = history.reduce(CalculatorBrain.left("0")) {
            result, item in
            result.apply(item: item)
        }
    }
    
    var totalCount: Int {
        history.count + temporaryKept.count
    }
    
    var slidingIndex: Float = 0 {
        didSet {
            keepHistory(upTo: Int(slidingIndex))
        }
    }
}
