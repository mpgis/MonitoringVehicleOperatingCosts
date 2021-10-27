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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            db.collection("cars")
                .addDocument(data: ["brand": brand,
                                    "model": model,
                                    "mileage": mileage,
                                    "fuelType": fuelType,
                                    "engine": engine,
                                    "body": body,
                                    "insurance": insurance,
                                    "service": service]) { (error) in
                    if let e = error {
                        print("Error while saving data to firestore \(e)")
                    } else {
                        print("Saved data")
                        self.dismiss(animated: true, completion: nil)
                    }
                }
        
        }
    }
    
}
