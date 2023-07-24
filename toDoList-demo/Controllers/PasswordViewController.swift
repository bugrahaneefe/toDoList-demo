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
                self.showAlert(
                    NSLocalizedString("Error sending password reset email: ",
                                      comment: "")+"\(error.localizedDescription)")
            } else {
                self.showAlert()
            }
        }
    }
    func showAlert() {
            let alert = UIAlertController(title: "",
                                          message: NSLocalizedString("Reset link is sent to your mail", comment: ""),
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
}

extension PasswordViewController {
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
