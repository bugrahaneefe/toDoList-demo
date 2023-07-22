//
//  PasswordViewController.swift
//  toDoList-demo
//
//  Created by Buğrahan Efe on 22.07.2023.
//

import UIKit
import Firebase

class PasswordViewController: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBAction func resetPassword(_ sender: UIButton) {
        guard let email = emailField.text, !email.isEmpty else {
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Error sending password reset email: \(error.localizedDescription)")
            } else {
                self.showAlert()
            }
        }
    }
    
    func showAlert() {
            let alert = UIAlertController(title: "", message: "Reset link is sent to your mail", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default) { _ in
            }
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
