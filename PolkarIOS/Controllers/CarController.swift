//
//  CarController.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 07/11/2021.
//

import UIKit
import Firebase

class CarController: UIViewController {
    
    var carUID: String = ""
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
    
}
