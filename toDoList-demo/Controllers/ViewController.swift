//
//  ViewController.swift
//  toDoList-demo
//
//  Created by Buğrahan Efe on 17.07.2023.
//

import UIKit
import CLTypingLabel

class ViewController: UIViewController {
    @IBOutlet weak var appTitle: CLTypingLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        appTitle.text = NSLocalizedString("Get Things Done With TODo", comment: "")
        navigationItemEdit()
    }
    @IBAction func getStartedPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.signInFromBeg, sender: self)
    }
    func navigationItemEdit() {
        navigationItem.backButtonTitle = ""
    }
}
