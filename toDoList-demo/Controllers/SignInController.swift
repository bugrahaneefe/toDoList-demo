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

        //navigation controller customization
        navigationItem.backButtonTitle = ""


    }
    

    @IBAction func ToSignUpButton(_ sender: UIButton) {
        
        performSegue(withIdentifier: K.goToSignUp, sender: self)
        
    }
    
    
    @IBAction func SignInButton(_ sender: UIButton) {
        
        if let email = emailText.text ,let password = passwordText.text {
         
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
              guard let strongSelf = self else { return }
                if let e = error{
                    print(e.localizedDescription)
                    //pop-up screen
                }else{
                    strongSelf.performSegue(withIdentifier: K.goToToDoList, sender: self)

                }
            }
            
        }

    }
    
    
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.toPasswordPage, sender: self)
        
    }
    

}
