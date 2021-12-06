//
//  AddEventViewController.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 14/11/2021.
//

import UIKit
import Firebase
import FirebaseFirestore

class AddEventViewController: UIViewController {
    
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var mileageTextField: UITextField!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var mileageReminderTextField: UITextField!
    @IBOutlet weak var reminderMileageLabel: UILabel!
    
    var car: Car?
    let db = Firestore.firestore()
    var types: [String] = ["Naprawa", "Wymiana czesci eksploatacyjnych", "Wymiana oleji i filtrow", "Inne"]
    
    var type: String?
    var date: String?
    var dateTimeStamp: Int?
    var reminder: Bool?
    var mileageReminder: Float?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typePicker.delegate = self
        typePicker.dataSource = self
        typePicker.tintColor = .white
        
        type = "Naprawa"
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if reminderSwitch.isOn {
            mileageReminderTextField.isHidden = false
            reminderMileageLabel.isHidden = false
        } else {
            mileageReminderTextField.isHidden = true
            reminderMileageLabel.isHidden = true
        }
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        date = dateFormatter.string(from: datePicker.date)
        let dateString = dateFormatter.date(from: date!)
        dateTimeStamp  = Int(dateString!.timeIntervalSince1970)
        
        if(reminderSwitch.isOn){
            reminder = true
            mileageReminder = Float(mileageReminderTextField.text!)! + Float(mileageTextField.text!)!
        } else {
            reminder = false
            mileageReminder = 0.0
        }
        addData()
        updateMileage()

    }
    
    func addData(){
        var ref: DocumentReference? = nil
        if let carUID = car?.UID,
           let date = date,
           let description = descriptionTextField.text,
           let mileage = Float(mileageTextField.text!),
           let price = Float(priceTextField.text!),
           let type = type,
           let time = dateTimeStamp,
           let reminder = reminder,
           let mileageReminder = mileageReminder,
           let model = car?.model,
           let brand = car?.brand{
            ref = db.collection(K.Event.colection)
                .addDocument(data: [K.Event.carUID: carUID,
                                    K.Event.date: date,
                                    K.Event.description: description,
                                    K.Event.mileage: mileage,
                                    K.Event.price: price,
                                    K.Event.type: type,
                                    K.Event.time: time,
                                    K.Event.reminder: reminder,
                                    K.Event.mileageReminder: mileageReminder,
                                    K.Event.model: model,
                                    K.Event.brand: brand,
                                    K.Event.userUID: Auth.auth().currentUser?.uid ?? ""]) { (error) in
                    if let e = error {
                        print("Error while saving data to firestore \(e)")
                    } else {
                        let docId = ref!.documentID
                        self.db.collection(K.Event.colection).document(docId).updateData([K.Event.UID : docId])

                        self.dismiss(animated: true, completion: nil)
                    }
                }
        }
    }
    
    func updateMileage() {
        let carRef = db.collection(K.Cars.colection).document(car?.UID ?? "")
        let mileage = Float(mileageTextField.text!)
        if(mileage! > car!.mileage) {
            carRef.updateData([
                K.Cars.mileage: Float(mileage!)
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Mileage successfully updated")
                }
            }
        }
    }
}

extension AddEventViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
      
      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          return types.count
      }
      
      func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          return types[row]
      }
      
      func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
          let selectedType = types[row]
          type = selectedType
      }
}
