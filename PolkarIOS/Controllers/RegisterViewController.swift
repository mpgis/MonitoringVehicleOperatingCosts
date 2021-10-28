//
//  RegisterViewController.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 20/10/2021.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = loginTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    self.addUserToDB()
                    self.performSegue(withIdentifier: "RegisterToWelcome", sender: self)
                }
            }
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func addUserToDB() {
        if let email = loginTextField.text,
           let name = userNameTextField.text {
            db.collection("users")
                .addDocument(data: ["email": email,
                                    "name": name,
                                    "cars": []]) { (error) in
                    if let e = error {
                        print("Error while saving data to firestore \(e)")
                    } else {
                        print("Saved user")
                    }
                }
        }
    }
}
