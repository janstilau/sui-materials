/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A single row to be displayed in a list of landmarks.
 */

import SwiftUI

struct LandmarkRow: View {
    // 传递过来, 一个 Model 来作为展示的数据来源.
    // 这里仅仅是展示, 并没有修改数据的操作, 所以, 直接直接就是赋值 Struct.
    var landmark: Landmark
    
    var body: some View {
        HStack {
            landmark.image
                .resizable()
                .frame(width: 50, height: 50)
                .padding()
            Text(landmark.name)
            Spacer()
        }
    }
}

struct LandmarkRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LandmarkRow(landmark: landmarks[0])
            LandmarkRow(landmark: landmarks[1])
            LandmarkRow(landmark: landmarks[3])
            LandmarkRow(landmark: landmarks[4])
        }
        .previewLayout(.fixed(width: 300, height: 120))
    }
}
