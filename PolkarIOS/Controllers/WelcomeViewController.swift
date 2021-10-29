//
//  ViewController.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 20/10/2021.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    var cars: [Car] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeLabel.text = "Witaj \(Auth.auth().currentUser?.email ?? "")"
        
        navigationItem.hidesBackButton = true
    }

    @IBAction func logOutPressed(_ sender: UIButton) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func addCarPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.Segue.welcomeToAddCar, sender: self)
    }
    
    
    
}




