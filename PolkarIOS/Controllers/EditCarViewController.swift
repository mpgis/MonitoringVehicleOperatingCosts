//
//  EditCarViewController.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 14/11/2021.
//

import UIKit
import Firebase

class EditCarViewController: UIViewController {
    
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var mileageTextField: UITextField!
    @IBOutlet weak var fuelTypeTextField: UITextField!
    @IBOutlet weak var fuelTankCapacityTextField: UITextField!
    @IBOutlet weak var engineTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    @IBOutlet weak var insuranceTextField: UITextField!
    @IBOutlet weak var serviceTextField: UITextField!
    
    var car: Car?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextField()
    }
    
    @IBAction func editCarPressed(_ sender: UIButton) {
        let carID = car?.UID
        if let brand = brandTextField.text,
           let model = modelTextField.text,
           let mileage = mileageTextField.text,
           let fuelType = fuelTypeTextField.text,
           let engine = engineTextField.text,
           let body = bodyTextField.text,
           let insurance = insuranceTextField.text,
           let service = serviceTextField.text,
           let fuelTankCapacity = fuelTankCapacityTextField.text {
            db.collection(K.Cars.colection).document(carID!).updateData([K.Cars.brand: brand,
                                                                         K.Cars.model: model,
                                                                         K.Cars.mileage: mileage,
                                                                         K.Cars.fuelType: fuelType,
                                                                         K.Cars.fuelTankCapacity: fuelTankCapacity,
                                                                         K.Cars.engine: engine,
                                                                         K.Cars.body: body,
                                                                         K.Cars.insurance: insurance,
                                                                         K.Cars.service: service]) { (error) in
                if let e = error {
                    print("Error while saving data to firestore \(e)")
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        }
    }
    
    func setTextField() {
        if let car = car {
            brandTextField.text = car.brand
            modelTextField.text = car.model
            mileageTextField.text = car.model
            fuelTypeTextField.text = car.fuelType
            fuelTankCapacityTextField.text = car.fuelTankCapacity
            engineTextField.text = car.engine
            bodyTextField.text = car.body
            insuranceTextField.text = car.insurance
            serviceTextField.text = car.service
        }
    }
}
