//
//  FuelViewController.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 14/11/2021.
//

import UIKit
import Firebase

class FuelViewController: UIViewController {
    
    @IBOutlet weak var fuelAmountTextField: UITextField!
    @IBOutlet weak var fuelPriceTextField: UITextField!
    @IBOutlet weak var fuelMileageTextField: UITextField!
    @IBOutlet weak var fuelSumLabel: UILabel!
    @IBOutlet weak var fuelAverageLabel: UILabel!
    @IBOutlet weak var fuelFullTankSwitch: UISwitch!
    
    var amount: Float = 0.0
    var price: Float = 0.0
    var mileage: Float = 0.0
    var sum: Float = 0.0
    var average: Float = 0.0
    
    var firstTime: Bool = true
    
    var car: Car?
    let db = Firestore.firestore()
    var fuels: [Fuel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    @IBAction func addAmount(_ sender: UITextField) {
        amount = Float(sender.text!)!
    }
    
    @IBAction func addPrice(_ sender: UITextField) {
        price = Float(sender.text!)!
    }
    
    @IBAction func addMileage(_ sender: UITextField) {
        mileage = Float(sender.text!)!
    }
    
    @IBAction func addFuelPressed(_ sender: UIButton) {
        
        sum = amount * price
        fuelSumLabel.text = String(sum)
        
        if(fuelFullTankSwitch.isOn) {
            print(fuels)
            print(firstTime)
        }
        
    }
    
    
    
    func loadData(){
        db.collection(K.Fuel.colection).whereField(K.Fuel.fuelCarUID, isEqualTo: car?.UID ?? "").order(by: K.Fuel.mileage, descending: true).addSnapshotListener { querySnapshot, error in
            
            self.fuels = []
            
            if let e = error {
                print("There was an issue retrieving data form firestore. \(e)")
            } else {
                if let snapshotDocument = querySnapshot?.documents {
                    for doc in snapshotDocument {
                        let data = doc.data()
                        if let UID = data[K.Fuel.UID] as? String,
                           let amount = data[K.Fuel.amount] as? String,
                           let mileage = data[K.Fuel.mileage] as? String,
                           let price = data[K.Fuel.price] as? String,
                           let sum = data[K.Fuel.sum] as? String,
                           let average = data[K.Fuel.average] as? String,
                           let fuelCarUID = data[K.Fuel.fuelCarUID] as? String,
                           let fullTank = data[K.Fuel.fullTank] as? String {

                            let newFuel = Fuel(UID: UID, amount: amount, mileage: mileage, price: price, sum: sum, average: average, fuelCarUID: fuelCarUID, fullTank: fullTank)
                            
                            self.fuels.append(newFuel)
                            self.firstTime = false
                            print("Test")
                        }
                           
                    }
                }
            }
        }
    }
}
