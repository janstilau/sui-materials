//
//  View+Ext.swift
//  ModernMVVM
//
//  Created by Vadim Bulavin on 3/20/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import SwiftUI

/*
 An AnyView allows changing the type of view used in a given view hierarchy. Whenever the type of view used with an AnyView changes, the old hierarchy is destroyed and a new hierarchy is created for the new type.
 */
// A type-erased view.
// @frozen struct AnyView


/*
 上面的例子中用户已登录时返回 Text，没登录返回 Button 类型。不是同一种类型，编译器因此抛出错误。为了解决这个问题我们很自然想到用一个通用的类型把所有的 View 都包起来，这样编译器可以编译通过。反正运行的时候是 View 就可以了。这就是 AnyView 的使用场景了，抹掉具体 View 类型，对外有一个统一的类型，上面的代码这样改一下就可以了：
 */
extension View {
    func eraseToAnyView() -> AnyView { AnyView(self) }
}
