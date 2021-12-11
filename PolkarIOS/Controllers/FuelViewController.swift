//
//  FuelViewController.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 14/11/2021.
//

import UIKit
import Firebase
import FirebaseFirestore

class FuelViewController: UIViewController {
    
    @IBOutlet weak var fuelAmountTextField: UITextField!
    @IBOutlet weak var fuelPriceTextField: UITextField!
    @IBOutlet weak var fuelMileageTextField: UITextField!
    @IBOutlet weak var fuelSumLabel: UILabel!
    @IBOutlet weak var fuelAverageLabel: UILabel!
    @IBOutlet weak var fuelFullTankSwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stationPicker: UIPickerView!
    
    var amount: Float?
    var price: Float?
    var mileage: Float?
    var sum: Float?
    var average: Float?
    var fullTank: Bool?
    
    var firstTime: Bool = true
    var stations: [String] = ["Orlen", "BP", "Shell", "CircleK", "Amic", "Moya"]
    var station = "Orlen"
    
    var car: Car?
    let db = Firestore.firestore()
    var fuels: [Fuel] = []
    var globalAverage: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        stationPicker.delegate = self
        stationPicker.dataSource = self
        stationPicker.tintColor = .white
        
        tableView.register(UINib(nibName: "FuelCell", bundle: nil), forCellReuseIdentifier: "Fuel Cell")
        
        print("FuelDidLoad")
        fullTank = false
        loadData()
    }
    
    @IBAction func addAmount(_ sender: UITextField) {
        amount = Float(sender.text!)!
    }
    
    @IBAction func addPrice(_ sender: UITextField) {
        price = Float(sender.text!)!
        sum = amount! * price!
        fuelSumLabel.text = String(format: "%.2f", sum!)
    }
    
    @IBAction func addMileage(_ sender: UITextField) {
        mileage = Float(sender.text!)!
        
        if(fuelFullTankSwitch.isOn && firstTime == false && fuels[0].fullTank == true) {
            average = amount! / (mileage! - fuels[0].mileage) * 100
            fuelAverageLabel.text = String(format: "%.2f", average!) + " L/100km"
        } else if(fuelFullTankSwitch.isOn && firstTime == false){
            var tmp_mileage: Float = 0.0
            var tmp_amount: Float = 0.0
            
            var i = 0
            
            while(fuels[i].fullTank != true || i > fuels.count - 1) {
                tmp_mileage = fuels[i].mileage
                tmp_amount += fuels[i].amount
                
                i += 1
            }
            average = (tmp_amount + amount!) / (mileage! - tmp_mileage) * 100
        } else {
            average = 0
        }
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        fuelMileageTextField.endEditing(true)
        fuelAmountTextField.endEditing(true)
        fuelPriceTextField.endEditing(true)
    }
    
    @IBAction func addFuelPressed(_ sender: UIButton) {
        
        fuelMileageTextField.endEditing(true)
        fuelAmountTextField.endEditing(true)
        fuelPriceTextField.endEditing(true)
        if(fuelFullTankSwitch.isOn) {
            fullTank = true
            addFuel()
        } else {
            fullTank = false
            addFuel()
        }
        if(firstTime == false){
            addAverageToCar()
        }
    }
    
    
    
    func loadData(){
        db.collection(K.Fuel.colection).whereField(K.Fuel.fuelCarUID, isEqualTo: car?.UID ?? "").order(by: K.Fuel.mileage, descending: true).getDocuments() { (querySnapshot, error) in
            if let e = error {
                print("There was an issue retrieving data form firestore. \(e)")
            } else {
                if let snapshotDocument = querySnapshot?.documents {
                    for doc in snapshotDocument {
                        let data = doc.data()
                        if let UID = data[K.Fuel.UID] as? String,
                           let amount = data[K.Fuel.amount] as? Float,
                           let mileage = data[K.Fuel.mileage] as? Float,
                           let price = data[K.Fuel.price] as? Float,
                           let sum = data[K.Fuel.sum] as? Float,
                           let average = data[K.Fuel.average] as? Float,
                           let fuelCarUID = data[K.Fuel.fuelCarUID] as? String,
                           let fullTank = data[K.Fuel.fullTank] as? Bool {

                            let newFuel = Fuel(UID: UID, amount: amount, mileage: mileage, price: price, sum: sum, average: average, fuelCarUID: fuelCarUID, fullTank: fullTank)
                            print("Tets")
                            self.fuels.append(newFuel)
                            self.firstTime = false
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                           
                    }
                }
            }
        }
    }
    
    func addFuel() {
        var ref: DocumentReference? = nil
        if let amount = amount,
           let mileage = mileage,
           let price = price,
           let sum = sum,
           let average = average,
           let fuelCarUID = car?.UID,
           let fuelType = car?.fuelType,
           let fullTank = fullTank {
            ref = db.collection(K.Fuel.colection)
                .addDocument(data: [K.Fuel.amount: amount,
                                    K.Fuel.mileage: mileage,
                                    K.Fuel.price: price,
                                    K.Fuel.sum: sum,
                                    K.Fuel.average: average,
                                    K.Fuel.fuelCarUID: String(fuelCarUID),
                                    K.Fuel.fullTank: fullTank,
                                    K.Fuel.station: String(station),
                                    K.Fuel.fuelType: fuelType]) { (error) in
                    if let e = error {
                        print("Error while saving data to firestore \(e)")
                    } else {
                        let docId = ref!.documentID
                        self.db.collection(K.Fuel.colection).document(docId).updateData([K.Fuel.UID : docId])
                                                
                        self.dismiss(animated: true, completion: nil)
                    }
                }
        
        }
    }
    
    func addAverageToCar() {
        var sumOfFuel: Float = 0.0
        
        for tmpFuel in fuels {
            sumOfFuel += tmpFuel.amount
        }
        sumOfFuel -= fuels[fuels.count - 1].amount
        globalAverage = sumOfFuel / (fuels[0].mileage - fuels[fuels.count - 1].mileage) * 100
        
        let carRef = db.collection(K.Cars.colection).document(car?.UID ?? "")

        carRef.updateData([
            K.Cars.averageFuelUsage: globalAverage
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
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

extension FuelViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fuels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Fuel Cell", for: indexPath) as! FuelCell
        
        cell.amountTextField.text = String(fuels[indexPath.row].amount)
        cell.averageTextField.text = String(fuels[indexPath.row].average)
        cell.sumTextField.text = String(fuels[indexPath.row].sum)
        if(fuels[indexPath.row].fullTank == true){
            cell.checkmarkImage.isHidden = false
        } else {
            cell.checkmarkImage.isHidden = true
        }
        
        return cell
    }
}

extension FuelViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
      
      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          return stations.count
      }
      
      func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          return stations[row]
      }
      
      func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
          let selectedStation = stations[row]
          station = selectedStation
      }
}

