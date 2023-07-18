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
        
        performSegue(withIdentifier: "goToSignUp", sender: self)
        
    }
    
    
    @IBAction func SignInButton(_ sender: UIButton) {
        
        if let email = emailText.text ,let password = passwordText.text {
         
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
              guard let strongSelf = self else { return }
                if let e = error{
                    print(e.localizedDescription)
                    //pop-up screen
                }else{
                    strongSelf.performSegue(withIdentifier: "goToToDoList", sender: self)

                }
            }
            
        }

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
