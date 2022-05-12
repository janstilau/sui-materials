import Foundation

struct Game {
    let start = RGB()
    var target = RGB.random()
    var round = 1
    var scoreRound = 0
    var scoreTotal = 0
    
    /// Check the guess values of an RGB object against a target RGB object.
    /// Compute the score out of 100. Add bonus points to very high scores.
    ///   - parameters:
    ///     - guess: The RGB object with guess values.
    mutating func check(guess: RGB) {
        let difference = lround(guess.difference(target: target) * 100.0)
        scoreRound = 100 - difference
        if difference == 0 {
            scoreRound += 100
        } else if difference == 1 { scoreRound += 50 }
        scoreTotal += scoreRound
    }
    
    /// Start a new round with a random RGB target object.
    mutating func startNewRound() {
        round += 1
        scoreRound = 0
        target = RGB.random()
        
        let trapezoid = makeTrapezoid()
        // JoinedShape<Triangle, JoinedShape<Square, FlippedShape<Triangle>>>
        // 虽然, 这里返回的是 Some Shape, 但是使用 typeOf 还是可以拿到该类型的最终类型.
        print(type(of: trapezoid))
    }
    
    /// Start a new game: Reset total score to 0.
    mutating func startNewGame() {
        round = 0
        scoreTotal = 0
        startNewRound()
    }
}


protocol Shape {
    func draw() -> String
}

struct Triangle: Shape {
    var size: Int
    func draw() -> String {
        var result: [String] = []
        for length in 1...size {
            result.append(String(repeating: "*", count: length))
        }
        return result.joined(separator: "\n")
    }
}
let smallTriangle = Triangle(size: 3)

struct FlippedShape<T: Shape>: Shape {
    var shape: T
    func draw() -> String {
        let lines = shape.draw().split(separator: "\n")
        return lines.reversed().joined(separator: "\n")
    }
}
let flippedTriangle = FlippedShape(shape: smallTriangle)

struct JoinedShape<T: Shape, U: Shape>: Shape {
    var top: T
    var bottom: U
    func draw() -> String {
        return top.draw() + "\n" + bottom.draw()
    }
}
let joinedTriangles = JoinedShape(top: smallTriangle, bottom: flippedTriangle)

struct Square: Shape {
    var size: Int
    func draw() -> String {
        let line = String(repeating: "*", count: size)
        let result = Array<String>(repeating: line, count: size)
        return result.joined(separator: "\n")
    }
}

func makeTrapezoid() -> some Shape {
    let top = Triangle(size: 2)
    let middle = Square(size: 2)
    let bottom = FlippedShape(shape: top)
    let trapezoid = JoinedShape(
        top: top,
        bottom: JoinedShape(top: middle, bottom: bottom)
    )
    return trapezoid
}

/*
 trapezoid 的返回值是 some Shape, 而不是一个具体的类型.
 let trapezoid = makeTrapezoid()
 print(trapezoid.draw())
 */

