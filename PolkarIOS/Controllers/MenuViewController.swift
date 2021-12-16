//
//  MenuViewController.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 07/11/2021.
//

import UIKit
import Firebase

class MenuViewController: UIViewController {
    
    var caller: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func yourCarsPressed(_ sender: UIButton) {
       
    }
    
    @IBAction func eventsPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func addEventPressed(_ sender: UIButton) {
        caller = "CarsToAddEvent"
        self.performSegue(withIdentifier: "MenuToCars", sender: self)
    }
    
    @IBAction func addFuelPressed(_ sender: UIButton) {
        caller = "CarsToAddFuel"
        self.performSegue(withIdentifier: "MenuToCars", sender: self)
    }
    
    @IBAction func stationStatPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func carStatPressed(_ sender: UIButton) {
        caller = "CarsToCarStat"
        self.performSegue(withIdentifier: "MenuToCars", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuToCars" {
            let destinationVC = segue.destination as! CarsViewController
            destinationVC.caller = caller
        }
    }
}
