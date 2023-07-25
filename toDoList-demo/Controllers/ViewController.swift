//
//  ViewController.swift
//  toDoList-demo
//
//  Created by Buğrahan Efe on 17.07.2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var appTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        appTitle.text = "Get Things Done With TODo".locally()
        navigationItemEdit()
    }
    @IBAction func getStartedPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Keys.signInFromBeg, sender: self)
    }
    func navigationItemEdit() {
        navigationItem.backButtonTitle = ""
    }
}
