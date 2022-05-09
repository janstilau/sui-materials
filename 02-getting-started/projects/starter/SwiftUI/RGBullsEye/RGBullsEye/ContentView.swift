import SwiftUI
/*
 @State 可以算作是, Model 值
 View 里面的内容, 根据 Model 里面的状态来展示.
 这就好像是, Model 里面控制了所有的逻辑, 然后使用统一的 UpdateView 方法, 将显示需要的数据, 从 Model 里面抽取出来, 更新 UI 的内容.
 */
struct ContentView: View {
    @State var game = Game()
    @State var guess: RGB
    @State var showScore = false
    
    var body: some View {
        VStack {
            Color(rgbStruct: game.target)
            if !showScore {
                Text("R: ??? G: ??? B: ???")
                    .padding()
            } else {
                Text(game.target.intString())
                    .padding()
            }
            Color(rgbStruct: guess)
            Text(guess.intString())
                .padding()
            ColorSlider(value: $guess.red, trackColor: .red)
            ColorSlider(value: $guess.green, trackColor: .green)
            ColorSlider(value: $guess.blue, trackColor: .blue)
            Button("Hit Me") {
                print("Hit me")
                showScore = true
                game.check(guess: self.guess)
            }
            // 这里, 不会专门的修改 showScore 的值, 双向绑定的.
            /*
                .default(Text("OK")) {
                    game.startNewRound()
                    guess = RGB()
                }
                这是 Alert.Button 的构造函数.
             */
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
        Group {
            ContentView(guess: RGB(red: 0.9, green: 0.9, blue: 0.7))
        }
    }
}

struct ColorSlider: View {
    // ColorSlider donot own @Binding Value
    @Binding var value: Double
    var trackColor: Color
    
    var body: some View {
        HStack {
            Text("0")
            // 这样赋值了之后, Slider 的值, 自动和 Value 绑定在一起了
            Slider(value: $value)
                .tint(trackColor)
            Text("255")
        }
        .padding(.horizontal)
    }
}
