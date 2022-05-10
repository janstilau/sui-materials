/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A view that clips an image to a circle and adds a stroke and shadow.
 */

import SwiftUI

struct CircleImage: View {
    // 这里就他们很怪. UI 层居然传输 UI 层的数据过来了
    // 传递一个 ImageName 在这里重新生成 Image 有什么问题.
    var image: Image
    
    var body: some View {
        image
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image("turtlerock"))
    }
}
