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

        //navigation controller customization
        navigationItem.backButtonTitle = ""
        navigationItem.hidesBackButton = true
        
        
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
           
           if (passwordField?.text == passwordField2?.text){
               if let email = emailField.text ,let password = passwordField.text {
                   Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                       if let e = error{
                           print(e.localizedDescription)
                           //pop-up screen
                       }else{
                           // Set the display name for the user
                           let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                           changeRequest?.displayName = self.fullNameField.text
                           changeRequest?.commitChanges(completion: { error in
                               if let error = error {
                                   print("Error setting display name: \(error)")
                               } else {
                                   // Display name set successfully
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

}


