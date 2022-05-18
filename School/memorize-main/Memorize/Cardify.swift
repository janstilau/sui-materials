//
//  Cardify.swift
//  Memorize
//
//  Created by Sergey Maslennikov on 25.11.2020.
//

import SwiftUI

extension View {
    func debug() -> Self {
        print(Mirror(reflecting: self).subjectType)
        return self
    }
    
    func size() -> Self {
        let _ = debug()
        print("Size is \(MemoryLayout<Self>.size)")
        return self
    }
}

// 一个 ViewModifier.
// 传入一个 View 过来, 使用 body(content: Content) 来生成一个新的 View.
// self.modifier(Cardify(isFaceUp: isFaceUp)) 生成一个 ContentModifer 对象, 里面存储了 Content 和 Modifier 的信息.
struct Cardify: AnimatableModifier {
    var rotation: Double
    
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    var isFaceUp: Bool {
        rotation < 90
    }
    
    var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }
    
    // body(content: Content) 可以是对 Content 进行各种 Modifier.
    // 也可以是创建一个新的 View, 将 Content 当做一个参数.
    
    /*
     body(content: Content) -> some View
     这个接口太过于抽象, 有可能是修改原来的 View, 也有可能是用原来的 View, 来创建新的 View.
     */
    func body(content: Content) -> some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                content
            }
            .opacity(isFaceUp ? 1 : 0)
            RoundedRectangle(cornerRadius: cornerRadius).fill()
                .opacity(isFaceUp ? 0 : 1)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0))
    }
    
    private let cornerRadius: CGFloat = 10.0
    private let edgeLineWidth: CGFloat = 3
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
