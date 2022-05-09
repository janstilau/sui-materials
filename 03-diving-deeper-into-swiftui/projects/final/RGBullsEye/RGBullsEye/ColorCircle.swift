import SwiftUI

/*
 相比较, UIKit 里面的各种构建.
 SwiftUI 这种声明式的代码, 就是布局的描述.
 
 如果粗略的理解.
 自己经常是写 UpdateViews 做统一的 UI 处理. 其中, 也经常是 removeAllSubviews 之后, 然后根据当前值构造 SubView, 根据 Model 进行设置之后, 添加到相应的位置上.
 Swift UI 其实可以这样理解, 不过, 它内部有着高效的 Diff 机制. 但理解成为, 每次数据的改变, 都是全 Remove 然后重新生成, 也是没有问题的.
 这也就能够解释的通, Body 里面, 仅仅是对于 View 应该展示的描述. 不做状态的管理.
 */
struct ColorCircle: View {
    let rgb: RGB
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // 给, 下面的 BGView 添加阴影效果. 而不是整个 View
            Circle()
                .fill(Color.element)
                .northWestShadow()
            
            // 根据, 外界传过来的值, 来设置中间填充颜色的值. 
            Circle()
                .fill(Color(red: rgb.red, green: rgb.green, blue: rgb.blue))
            // 这个 Padding, 是向内进行压缩的值.
                .padding(20)
        }
        // 根据, 外界传过来的值, 来设置 BodyView 的大小.
        .frame(width: size, height: size)
    }
}

// 在自定义 View 的过程里面, 也可以进行 Preview
// 这对于 View 的编写来说, 非常重要.
// 调试的时候, 编译等待的时间, 实在太多了. 这种调试的速度, 可以比得上 H5 了
struct ColorCircle_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.element
            ColorCircle(rgb: RGB.init(red: 1, green: 0, blue: 0), size: 200)
        }
        .frame(width: 300, height: 300)
        .previewLayout(.sizeThatFits)
    }
}
