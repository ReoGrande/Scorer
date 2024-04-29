//
//  GameViewController.swift
//  Scorer
//
//  Created by user on 4/21/24.
//

import UIKit

class GameViewController: UIViewController {
    var currentGame: Game?
    @IBOutlet weak var textLabel:UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    textLabel?.text = "Click the button…"
    }

    @IBAction func onButtonTap(sender: UIButton)
    {
    textLabel?.text = "Hello world!"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
