
import UIKit

class AboutusViewController: UIViewController {

    @IBOutlet weak var feedbackTV:UITextView!
    
    @IBOutlet weak var Mainview: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackTV.layer.borderWidth = 1.0
        feedbackTV.layer.borderColor = UIColor.white.cgColor
        feedbackTV.layer.cornerRadius = 10.0
        feedbackTV.clipsToBounds = true
        // Do any additional setup after loading the view.
        applyCornerRadiusToBottomCorners(view: Mainview, cornerRadius: 35)

    }
    
    
    @IBAction func backbtnPressed(_ sender:UIButton)
    {
        self.dismiss(animated: true)
    }
}
