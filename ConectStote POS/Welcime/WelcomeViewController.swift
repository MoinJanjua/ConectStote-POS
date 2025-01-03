//
//  WelcomeViewController.swift
//  ConectStote POS
//
//  Created by Unique Consulting Firm on 30/12/2024.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var welcomeImg:UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        roundCornerView(image: welcomeImg)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func startbtnPressed(_ sender:UIButton)
    {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
}
