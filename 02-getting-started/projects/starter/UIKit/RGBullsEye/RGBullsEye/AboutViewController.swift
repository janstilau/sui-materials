
import UIKit

class AboutViewController: UIViewController {
    @IBAction func close(sender: AnyObject) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
