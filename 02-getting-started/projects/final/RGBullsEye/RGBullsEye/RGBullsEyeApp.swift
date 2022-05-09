
import SwiftUI

@main
struct RGBullsEyeApp: App {
    var body: some Scene {
        WindowGroup {
            // ContentView 的调用原则, 还是 Swift 构造函数的语法.
            // 对象内无法初始化的属性, 要在构造函数内完成初始化. 
            ContentView(guess: RGB())
        }
    }
}
