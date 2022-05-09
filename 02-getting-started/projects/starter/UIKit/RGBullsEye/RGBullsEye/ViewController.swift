import UIKit

/*
 实际上, 这个 VC 里面的代码, 没有 View 的构建的过程.
 这个过程, 是被 Xib 所接管了. 
 */
class ViewController: UIViewController {
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var targetTextLabel: UILabel!
    @IBOutlet weak var guessLabel: UILabel!
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    let game = BullsEyeGame()
    var theRgb = RGB()
    
    @IBAction func aSliderMoved(sender: UISlider) {
        switch sender {
        case redSlider:
            theRgb.red = Int(sender.value)
            redLabel.text = "R \(theRgb.red)"
        case greenSlider:
            theRgb.green = Int(sender.value)
            greenLabel.text = "G \(theRgb.green)"
        case blueSlider:
            theRgb.blue = Int(sender.value)
            blueLabel.text = "B \(theRgb.blue)"
        default: break
        }
        guessLabel.backgroundColor = UIColor(rgbStruct: theRgb)
    }
    
    @IBAction func showAlert(sender: AnyObject) {
        // display target values beneath target color
        targetTextLabel.text = """
      R \(game.targetValue.red)   \
      G \(game.targetValue.green)   \
      B \(game.targetValue.blue)
    """
        
        let difference = game.check(guess: theRgb)
        var title = "Not even close..."  // default title if difference >= 10
        if difference == 0 {
            title = "Perfect!"
        } else if difference < 5 {
            title = "You almost had it!"
        } else if difference < 10 {
            title = "Pretty good!"
        }
        
        let message = "you scored \(game.scoreRound) points"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            self.game.startNewRound()
            self.updateView()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func startOver(sender: AnyObject) {
        game.startNewGame()
        updateView()
    }
    
    // 集中将 UI 相关的逻辑, 放到一个地方, 会让代码清晰的多.
    func updateView() {
        targetLabel.backgroundColor = UIColor(rgbStruct: game.targetValue)
        targetTextLabel.text = "match this color"
        
        theRgb = game.startValue
        guessLabel.backgroundColor = UIColor(rgbStruct: theRgb)
        redLabel.text = "R \(theRgb.red)"
        greenLabel.text = "G \(theRgb.green)"
        blueLabel.text = "B \(theRgb.blue)"
        
        redSlider.value = Float(theRgb.red)
        greenSlider.value = Float(theRgb.green)
        blueSlider.value = Float(theRgb.blue)
        
        roundLabel.text = "Round: \(game.round)"
        scoreLabel.text = "Score: \(game.scoreTotal)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
}
