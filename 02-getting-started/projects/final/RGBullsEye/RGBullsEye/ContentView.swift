
import SwiftUI

/*
 MVVM 中, VC 的责任是构建 View, 以及 ViewAction 对于 ModelAction 的触发, Model 的信号和 View 的绑定.
 这些, 在 SwiftUI 中, 使用 Body 函数就能搞定了.
 
 所以, 在 Body 中, 其实就是做的上面的三件事.
 */

struct ContentView: View {
    // ViewModel
    @State var gameController = Game()
    // ViewStateModel
    @State var guess: RGB
    // ViewStateModel
    @State var showScore = false
    
    var body: some View {
        
        VStack {
            Circle()
                .fill(Color(rgbStruct: gameController.target))
            if !showScore {
                Text("R: ??                                                                                                                                                           ? G: ??? B: ???")
                    .padding()
            } else {
                Text(gameController.target.intString())
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
                gameController.check(guess: guess)
            }
            /*
             public func alert(isPresented: Binding<Bool>, content: () -> Alert) -> some View
             */
            .alert(isPresented: $showScore) {
                Alert(
                    title: Text("Your Score"),
                    message: Text(String(gameController.scoreInCurrentRound)),
                    dismissButton: .default(Text("OK")) {
                        gameController.startNewRound()
                        guess = RGB()
                    })
            }
            
            

        }
    }
}

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


struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView(guess: RGB())
    }
}
