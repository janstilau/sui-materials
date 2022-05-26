import SwiftUI
import Combine

/*
 ObservableObject 中, 如果有 @Published, 那么 Published 属性的改变, 会自动的触发 objectWillChange 信号的发射.
 
 Summary
 
 // 在改变之前, 发射信号.
 // View 那里, 应该仅仅是设置脏状态, 在 Runloop 中统一进行刷新.
 A type of object with a publisher that emits before the object has changed.
 Declaration
 
 protocol ObservableObject : AnyObject
 Discussion
 
 By default an ObservableObject synthesizes an objectWillChange publisher that emits the changed value before any of its @Published properties changes.
 class Contact: ObservableObject {
 @Published var name: String
 @Published var age: Int
 
 init(name: String, age: Int) {
 self.name = name
 self.age = age
 }
 
 func haveBirthday() -> Int {
 age += 1
 return age
 }
 }
 
 let john = Contact(name: "John Appleseed", age: 24)
 cancellable = john.objectWillChange
 .sink { _ in
 print("\(john.age) will change")
 }
 print(john.haveBirthday())
 // Prints "24 will change"
 // Prints "25"
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
    
    // Model Action, 会触发信号的改变.
    // @Published 的存在, 使得信号的改变, 变得异常简单. 在爷
    func keepHistory(upTo index: Int) {
        precondition(index <= totalCount, "Out of index.")
        
        let total = history + temporaryKept
        
        // 通过 Slider 的值, 对
        history = Array(total[..<index])
        temporaryKept = Array(total[index...])
        
        // 每次都是从头到脚的一次遍历.
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
    
    // Index 的改变, 有着对于 model 的改变.
    // 对于 Model 的改变,
    var slidingIndex: Float = 0 {
        didSet {
            keepHistory(upTo: Int(slidingIndex))
        }
    }
}
