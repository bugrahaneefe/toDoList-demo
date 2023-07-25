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
                                   self.showAlert("Error setting display name: ".locally()+"\(error)")
                               } else {
                                   self.performSegue(withIdentifier: Keys.goToSignIn, sender: self)
                               }
                           })
                       }
                   }
               }
           }
    }
    @IBAction func goSignInButton(_ sender: UIButton) {
        performSegue(withIdentifier: Keys.goToSignIn, sender: self)
    }
    func navigationItemEdit() {
        navigationItem.backButtonTitle = ""
        navigationItem.hidesBackButton = true
    }
}
