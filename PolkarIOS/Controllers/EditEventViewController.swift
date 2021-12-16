//
//  EditEventViewController.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 13/12/2021.
//

import UIKit
import Firebase
import FirebaseFirestore

class EditEventViewController: UIViewController {
    
    
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var mileageTextField: UITextField!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var reminderMileage: UITextField!
    
    var event: Event?
    var types: [String] = ["Naprawa", "Wymiana czesci eksploatacyjnych", "Wymiana oleji i filtrow", "Inne"]
    var type: String?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typePicker.delegate = self
        typePicker.dataSource = self
        typePicker.tintColor = .white
        
        loadData()
    }
    
    func loadData() {
        descriptionTextField.text = event!.description
        costTextField.text = String(event!.price)
        mileageTextField.text = String(event!.mileage)
        reminderSwitch.isOn = Bool(event!.reminder)
        reminderMileage.text = String(event!.mileageReminder)
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
        var reminder = false
        if reminderSwitch.isOn {
            reminder = true
        }
        let eventUID = event?.UID
        if let description = descriptionTextField.text,
           let cost = Float(costTextField.text!),
           let mileage = Float(mileageTextField.text!),
           let reminderMileage = Float(reminderMileage.text!){
            db.collection(K.Event.colection).document(eventUID!).updateData([K.Event.description: description,
                                                                            K.Event.price: cost,
                                                                            K.Event.mileage: mileage,
                                                                            K.Event.mileageReminder: reminderMileage,
                                                                            K.Event.reminder: reminder,
                                                                            K.Event.type: type!]) { (error) in
                if let e = error {
                    print("Error while updating event \(e)")
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func deleteEventPressed(_ sender: UIButton) {
        let eventUID = event?.UID
        db.collection(K.Event.colection).document(eventUID!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension EditEventViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
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
