//
//  AddCarController.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 27/10/2021.
//

import UIKit
import Firebase
import FirebaseFirestore

class AddCarController: UIViewController {
    
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var mileageTextField: UITextField!
    @IBOutlet weak var fuelTypeTextField: UITextField!
    @IBOutlet weak var engineTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    @IBOutlet weak var insuranceTextField: UITextField!
    @IBOutlet weak var serviceTextField: UITextField!
    
    let db = Firestore.firestore()
    var userID = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserID()
    }
    
    @IBAction func addCarPressed(_ sender: UIButton) {
        if let brand = brandTextField.text,
           let model = modelTextField.text,
           let mileage = mileageTextField.text,
           let fuelType = fuelTypeTextField.text,
           let engine = engineTextField.text,
           let body = bodyTextField.text,
           let insurance = insuranceTextField.text,
           let service = serviceTextField.text {
            db.collection(K.Cars.colection)
                .addDocument(data: [K.Cars.brand: brand,
                                    K.Cars.model: model,
                                    K.Cars.mileage: mileage,
                                    K.Cars.fuelType: fuelType,
                                    K.Cars.engine: engine,
                                    K.Cars.body: body,
                                    K.Cars.insurance: insurance,
                                    K.Cars.service: service,
                                    K.Cars.emial: Auth.auth().currentUser?.email ?? "",
                                    K.Cars.time: Date().timeIntervalSince1970]) { (error) in
                    if let e = error {
                        print("Error while saving data to firestore \(e)")
                    } else {
                        self.addCarToUser()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
        
        }
    }
    
    func addCarToUser() {
        db.collection(K.Cars.colection).whereField(K.Cars.emial, isEqualTo: Auth.auth().currentUser?.email ?? "").order(by: K.Cars.time, descending: true).limit(to: 1).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.db.collection(K.Users.colection).document(self.userID).getDocument { (doc, error) in
                        
                        if let doc = doc, doc.exists {
                            let data = doc.data()
                            var cars = data![K.Users.cars] as! [String]
                            cars.append(document.documentID)
                            self.db.collection(K.Users.colection).document(self.userID).updateData([K.Users.cars: cars])
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
            }
        }
    }
    
    func getUserID(){
        var userID: String = "Error"
        
        db.collection(K.Users.colection).whereField(K.Users.email, isEqualTo: Auth.auth().currentUser?.email ?? "").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    userID = document.documentID
                    self.setUserID(id: userID)
                }
            }
        }
    }
    
    func setUserID(id: String) {
        userID = id
    }
    
}
