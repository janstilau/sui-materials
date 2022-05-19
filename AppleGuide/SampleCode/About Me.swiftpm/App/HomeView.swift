/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

extension View {
    func border() -> some View {
        return self.border(Color.red, width: 1)
    }
}

struct HomeView: View {
    
    var body: some View {
        VStack {
            Text("All About")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .border()

            Image(information.image)
            /*
             Summary
             Sets the mode by which SwiftUI resizes an image to fit its space.
             Declaration

             func resizable(capInsets: EdgeInsets = EdgeInsets(), resizingMode: Image.ResizingMode = .stretch) -> Image
             Parameters

             capInsets
             Inset values that indicate a portion of the image that SwiftUI doesn’t resize.
             resizingMode
             The mode by which SwiftUI resizes the image.
             Returns

             An image, with the new resizing behavior set.
             */
            // 当使用了 resizable 之后, ImageView 的尺寸, 就会沾满父 View 了.
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
                .padding(40)
                .border()

            Text(information.name)
                .font(.title)
                .border()
        }
        .border()
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
