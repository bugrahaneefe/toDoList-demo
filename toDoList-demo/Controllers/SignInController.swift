//
//  SignInController.swift
//  toDoList-demo
//
//  Created by Buğrahan Efe on 17.07.2023.
//

import UIKit
import Firebase

class SignInController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItemEdit()
    }
    @IBAction func toSignUpButton(_ sender: UIButton) {
        performSegue(withIdentifier: K.goToSignUp, sender: self)
    }
    /// Checks authentication and if it is valid, let user sign in
    /// - Parameter sender: UIButton
    @IBAction func toSignInButton(_ sender: UIButton) {
        if let email = emailText.text, let password = passwordText.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
                guard let strongSelf = self else { return }
                if let error = error {
                    self?.showAlert("\(error.localizedDescription)")
                } else {
                    strongSelf.performSegue(withIdentifier: K.goToToDoList, sender: self)
                }
            }
        }
    }
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.toPasswordPage, sender: self)
    }
    func navigationItemEdit() {
        navigationItem.backButtonTitle = ""
    }
}

extension SignInController {
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
