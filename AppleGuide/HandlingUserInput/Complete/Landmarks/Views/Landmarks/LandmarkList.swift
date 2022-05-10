/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A view showing a list of landmarks.
 */

import SwiftUI

// 这个增加一个 View, 不更好吗???
struct LandmarkList: View {
    // modelData 是根据 @EnvironmentObject 传递过来的. 
    @EnvironmentObject var modelData: ModelData
    @State private var showFavoritesOnly = false
    
    // 一个计算属性.
    // 每次, showFavoritesOnly 的修改, 都会引起 Body 的重新获取.
    // 在 Body 的重新获取的时候, filteredLandmarks 会根据状态值, 筛选出最终要显示到屏幕上的数据.
    // 而这些数据, 最终被 Body 使用. 而 Body 和 UI 的最终展示息息相关.
    var filteredLandmarks: [Landmark] {
        modelData.landmarks.filter { landmark in
            (!showFavoritesOnly || landmark.isFavorite)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                // List 第一项, 是一个特殊的 View
                // 从这里来看, $showFavoritesOnly 应该返回的是一个 Subject 对象.
                // 它的当前值, 是 View 的当前表现.
                // 它的改动, 会触发 View 的 Body 重新计算.
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favorites only")
                }
                
                // 然后是根据 Model 数组, 来生成了各种各样的 View.
                // 之前, ForEach 中的内容, 是 List 的实际内容.
                // 但是, 因为上面又增加了一个 Toggle, 原来的数据, 需要 ForEach 这个遍历来生成了.
                // 这里和 QML 的写法, 有很多的雷同. 
                ForEach(filteredLandmarks) { landmark in
                    NavigationLink {
                        LandmarkDetail(landmark: landmark)
                    } label: {
                        LandmarkRow(landmark: landmark)
                    }
                }
            }
            .navigationTitle("Landmarks")
        }
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkList()
            .environmentObject(ModelData())
    }
}
