
import SwiftUI

/*
 MVVM 中, VC 的责任是构建 View, 以及 ViewAction 对于 ModelAction 的触发, Model 的信号和 View 的绑定.
 这些, 在 SwiftUI 中, 使用 Body 函数就能搞定了.
 
 所以, 在 Body 中, 其实就是做的上面的三件事.
 
 @State 所代表的, 不仅仅是一个 Model 了, 而是一个 ViewModel, 是 Controller 层的东西.
 里面包含真正的 Model, 以及各种业务函数, 在 ViewAction 中触发.
 */

struct ContentView: View {
    // ViewModel
    @State var game = Game()
    // ViewStateModel
    @State var guess: RGB
    // ViewStateModel
    @State var showScore = false
    
    // 无法通过, var staticShowScore = false 来构建
    // 无法在 Button 点击函数里面, 调用 staticShowScore = true, 编译报错, self is immutable
    var staticShowScore = false
    
    var body: some View {
        VStack {
            Circle()
                .fill(Color(rgbStruct: game.target))
            if !showScore {
                Text("R: ??? G: ??? B: ???")
                    .padding()
            } else {
                Text(game.target.intString())
                    .padding()
            }
            Circle()
                .fill(Color(rgbStruct: guess))
            Text(guess.intString())
                .padding()
            // @State 里面的 red, 并不是一个 @State 的值, 也可以当做是 Subject 来进行 使用了.
            ColorSlider(value: $guess.red, trackColor: .red)
            ColorSlider(value: $guess.green, trackColor: .green)
            ColorSlider(value: $guess.blue, trackColor: .blue)
            Button("Hit Me!") {
                showScore = true
//                staticShowScore = true
                game.check(guess: guess)
            }
            .alert(isPresented: $showScore) {
                Alert(
                    title: Text("Your Score"),
                    message: Text(String(game.scoreRound)),
                    dismissButton: .default(Text("OK")) {
                        game.startNewRound()
                        guess = RGB()
                    })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(guess: RGB())
    }
}

// 子类化,
struct ColorSlider: View {
    // 从目前来看, @Binding 里面, 会存储一个 Subject 的值.
    @Binding var value: Double
    var trackColor: Color
    
    var body: some View {
        HStack {
            Text("0")
            // $value 会暴露出, 里面存储的 Subject 的值.
            Slider(value: $value)
                .accentColor(trackColor)
            Text("255")
        }
        .padding(.horizontal)
    }
}
