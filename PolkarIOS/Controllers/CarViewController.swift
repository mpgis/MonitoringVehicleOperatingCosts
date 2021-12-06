//
//  CarController.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 07/11/2021.
//

import UIKit
import Firebase

class CarViewController: UIViewController {
    
    var carUID: String = ""
    var car: Car?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(carUID)
        
    }
    
    @IBAction func deleteCarPressed(_ sender: UIButton) {
        db.collection(K.Cars.colection).document(carUID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                self.deleteCarInUser()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func deleteCarInUser() {
        db.collection(K.Users.colection).document(Auth.auth().currentUser?.uid ?? "").getDocument { (doc, error) in
            if let doc = doc, doc.exists {
                let data = doc.data()
                var cars = data![K.Users.cars] as! [String]
                cars.removeAll(where: { $0  == self.carUID})
                self.db.collection(K.Users.colection).document(Auth.auth().currentUser?.uid ?? "").updateData([K.Users.cars: cars])
            } else {
                print("Document does not exist")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CarToEdit" {
            let destinationVC = segue.destination as! EditCarViewController
            destinationVC.car = car
        }
        
        if segue.identifier == "CarToFuel" {
            let destinationVC = segue.destination as! FuelViewController
            destinationVC.car = car
        }
        
        if segue.identifier == "CarToEvent" {
            let destinationVC = segue.destination as! AddEventViewController
            destinationVC.car = car
        }
    }
    
}
