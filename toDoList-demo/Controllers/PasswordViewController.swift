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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func resetPassword(_ sender: UIButton) {
        guard let email = emailField.text, !email.isEmpty else {
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.showAlert(String(format:
                    "err.sent.reset.password".locally()
                                      ,error.localizedDescription))
            } else {
                self.showAlert()
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "",
                                      message: "sent.reset.password".locally(),
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "ok".locally(), style: .default) { _ in
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
