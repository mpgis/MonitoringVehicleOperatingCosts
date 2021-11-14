//
//  AddCarController.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 27/10/2021.
//

import UIKit
import Firebase
import FirebaseFirestore

class AddCarViewController: UIViewController {
    
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var mileageTextField: UITextField!
    @IBOutlet weak var fuelTypeTextField: UITextField!
    @IBOutlet weak var engineTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    @IBOutlet weak var insuranceTextField: UITextField!
    @IBOutlet weak var serviceTextField: UITextField!
    @IBOutlet weak var fuelTankCapacityTextField: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addCarPressed(_ sender: UIButton) {
        var ref: DocumentReference? = nil
        if let brand = brandTextField.text,
           let model = modelTextField.text,
           let mileage = mileageTextField.text,
           let fuelType = fuelTypeTextField.text,
           let engine = engineTextField.text,
           let body = bodyTextField.text,
           let insurance = insuranceTextField.text,
           let service = serviceTextField.text,
           let fuelTankCapacity = fuelTankCapacityTextField.text {
            ref = db.collection(K.Cars.colection)
                .addDocument(data: [K.Cars.brand: brand,
                                    K.Cars.model: model,
                                    K.Cars.mileage: mileage,
                                    K.Cars.fuelType: fuelType,
                                    K.Cars.fuelTankCapacity: fuelTankCapacity,
                                    K.Cars.engine: engine,
                                    K.Cars.body: body,
                                    K.Cars.insurance: insurance,
                                    K.Cars.service: service,
                                    K.Cars.userUID: Auth.auth().currentUser?.uid ?? "",
                                    K.Cars.time: Date().timeIntervalSince1970]) { (error) in
                    if let e = error {
                        print("Error while saving data to firestore \(e)")
                    } else {
                        let docId = ref!.documentID
                        self.db.collection(K.Cars.colection).document(docId).updateData([K.Cars.UID : docId])
                                                
                        self.addCarToUser()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
        
        }
    }
    
    func addCarToUser() {
        db.collection(K.Cars.colection).whereField(K.Cars.userUID, isEqualTo: Auth.auth().currentUser?.uid ?? "").order(by: K.Cars.time, descending: true).limit(to: 1).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.db.collection(K.Users.colection).document(Auth.auth().currentUser?.uid ?? "").getDocument { (doc, error) in
                        if let doc = doc, doc.exists {
                            let data = doc.data()
                            var cars = data![K.Users.cars] as! [String]
                            cars.append(document.documentID)
                            self.db.collection(K.Users.colection).document(Auth.auth().currentUser?.uid ?? "").updateData([K.Users.cars: cars])
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
            }
        }
    }
    
}
