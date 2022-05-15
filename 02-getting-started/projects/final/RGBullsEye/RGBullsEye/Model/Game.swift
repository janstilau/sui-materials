import Foundation


/*
 ViewModel 类. 就是 MVVM 中的 Controller.
 里面存储需要使用的 Model 类.
 
 在 ViewModel 里面, 定义相对应的 model Action, 在 ViewAction 中直接调用.
 */
struct Game {
    // 最终的数据.
    var target = RGB.random()
    var round = 1
    var scoreInCurrentRound = 0
    var scoreTotal = 0
    
    /// Check the guess values of an RGB object against a target RGB object.
    /// Compute the score out of 100. Add bonus points to very high scores.
    ///   - parameters:
    ///     - guess: The RGB object with guess values.
    mutating func check(guess: RGB) {
        /*
         guess 是外界传递过来的. 是一个 ViewState. ViewAction 修改自己的 ViewState 数据, 然后在 Btn 的 ViewAction 的时候, 调用控制层的方法, 传入进行 ModelAction.
         */
        let difference = lround(guess.difference(target: target) * 100.0)
        scoreInCurrentRound = 100 - difference
        if difference == 0 {
            scoreInCurrentRound += 100
        } else if difference == 1 {
            scoreInCurrentRound += 50
        }
        scoreTotal += scoreInCurrentRound
    }
    
    /// Start a new round with a random RGB target object.
    mutating func startNewRound() {
        round += 1
        scoreInCurrentRound = 0
        target = RGB.random()
    }
    
    /// Start a new game: Reset total score to 0.
    mutating func startNewGame() {
        round = 0
        scoreTotal = 0
        startNewRound()
    }
}
