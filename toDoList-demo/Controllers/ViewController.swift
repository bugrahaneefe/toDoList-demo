//
//  ViewController.swift
//  toDoList-demo
//
//  Created by Buğrahan Efe on 17.07.2023.
//

import UIKit
import CLTypingLabel

class ViewController: UIViewController {

    //Cocoapods
    @IBOutlet weak var appTitle: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appTitle.text = "Get Things Done With TODo"

        //navigation controller customization
        navigationItem.backButtonTitle = ""
        
    }

    @IBAction func getStartedPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSignInFromBeginning", sender: self)
    }
    
}

