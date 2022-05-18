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
    
    /*
     ViewModify 是一个很自由的 Protocol. 就是可以根据一个 View, 来创建另外的一个 View
     是设置这个 View, 还是将这个 View 作为积木组合出一个新的 View. 这个实现其实并没有强制的要求.
     */
    func body(content: Content) -> some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                content
            }
            .opacity(isFaceUp ? 1 : 0)
            // 背景色, 以及 content 一直都在 View 上, 这样 match up 修改了之后, 动画才能正常.
            RoundedRectangle(cornerRadius: cornerRadius).fill()
                .opacity(isFaceUp ? 0 : 1)
        }
        // 在这里, 进行了 Flip 的动画效果的设置.
        // rotation 发生了变化, 会触发 3D 旋转效果. 
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
