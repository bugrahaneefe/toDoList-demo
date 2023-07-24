//
//  SignUpController.swift
//  toDoList-demo
//
//  Created by Buğrahan Efe on 17.07.2023.
//

import UIKit
import Firebase

class SignUpController: UIViewController {
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordField2: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItemEdit()
    }
    /// Stores information of user to database and register user
    /// - Parameter sender: UIButton
    @IBAction func signUpPressed(_ sender: UIButton) {
           if passwordField?.text == passwordField2?.text {
               if let email = emailField.text, let password = passwordField.text {
                   Auth.auth().createUser(withEmail: email, password: password) { _, error in
                       if let error = error {
                           self.showAlert("\(error.localizedDescription)")
                       } else {
                           let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                           changeRequest?.displayName = self.fullNameField.text
                           changeRequest?.commitChanges(completion: { error in
                               if let error = error {
                                   self.showAlert(NSLocalizedString("Error setting display name: ",
                                                                    comment: "")+"\(error)")
                               } else {
                                   self.performSegue(withIdentifier: K.goToSignIn, sender: self)
                               }
                           })
                       }
                   }
               }
           }
    }
    @IBAction func goSignInButton(_ sender: UIButton) {
        performSegue(withIdentifier: K.goToSignIn, sender: self)
    }
    func navigationItemEdit() {
        navigationItem.backButtonTitle = ""
        navigationItem.hidesBackButton = true
    }
}
extension SignUpController {
    /// Alert message
    /// - Parameter message: String
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
