//
//  CarStatViewController.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 13/12/2021.
//

import UIKit
import Firebase
import FirebaseFirestore

class CarStatViewController: UIViewController {
    
    @IBOutlet weak var monthFuelLabel: UILabel!
    @IBOutlet weak var allFuelLabel: UILabel!
    @IBOutlet weak var averageFuelLabel: UILabel!
    @IBOutlet weak var monthEventLabel: UILabel!
    @IBOutlet weak var allEventLabel: UILabel!
    @IBOutlet weak var eventCountLabel: UILabel!
    @IBOutlet weak var fuelCountLabel: UILabel!
    
    var car: Car?
    
    let db = Firestore.firestore()
    var fuels: [Fuel] = []
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadEventData()
    }
    
    func loadLabels() {
        var allFuel:Float = 0.0
        var monthFuel: Float = 0.0
        var allEvent: Float = 0.0
        var monthEvent: Float = 0.0
        
        let timeNow = Int(Date().timeIntervalSince1970.rounded())
        let last30days = timeNow - 2592000
        
        for event in events {
            allEvent += event.price
            if event.time! > last30days {
                monthEvent += event.price
            }
        }
        
        for fuel in fuels {
            allFuel += fuel.sum
            if fuel.time! > last30days {
                monthFuel += fuel.sum
            }
        }
        
        
        let average = car?.average
        averageFuelLabel.text = String(average!)
        eventCountLabel.text = String(events.count)
        fuelCountLabel.text = String(fuels.count)
        monthFuelLabel.text = String(format: "%.2f", monthFuel)
        allFuelLabel.text = String(format: "%.2f", allFuel)
        monthEventLabel.text = String(format: "%.2f", monthEvent)
        allEventLabel.text = String(format: "%.2f", allEvent)
    }
    
    func loadEventData() {
        db.collection(K.Event.colection).whereField(K.Event.carUID, isEqualTo: car?.UID ?? "").order(by: K.Event.mileage, descending: true).getDocuments { (querySnapshot, error) in
            if let e = error {
                print("There was an issue retrieving data form firestore. \(e)")
            } else {
                if let snapshotDocument = querySnapshot?.documents {
                    for doc in snapshotDocument {
                        let data = doc.data()
                        if let UID = data[K.Event.UID] as? String,
                           let carUID = data[K.Event.carUID] as? String,
                           let date = data[K.Event.date] as? String,
                           let description = data[K.Event.description] as? String,
                           let mileage = data[K.Event.mileage] as? Float,
                           let price = data[K.Event.price] as? Float,
                           let type = data[K.Event.type] as? String,
                           let reminder = data[K.Event.reminder] as? Bool,
                           let mileageReminder = data[K.Event.mileageReminder] as? Float,
                           let model = data[K.Event.model] as? String,
                           let brand = data[K.Event.brand] as? String,
                           let userUID = data[K.Event.userUID] as? String,
                           let time = data[K.Event.time] as? Int {
                         
                            let newEvent = Event(UID: UID, carUID: carUID, date: date, description: description, mileage: mileage, price: price, type: type, reminder: reminder, mileageReminder: mileageReminder, model: model, brand: brand, userUID: userUID, time: time)
                            self.events.append(newEvent)
                        }
                    }
                }
            }
            self.loadFuelData()
        }
    }
    
    func loadFuelData() {
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
                           let fullTank = data[K.Fuel.fullTank] as? Bool,
                           let time = data[K.Fuel.time] as? Int {

                            let newFuel = Fuel(UID: UID, amount: amount, mileage: mileage, price: price, sum: sum, average: average, fuelCarUID: fuelCarUID, fullTank: fullTank, time: time)
                            self.fuels.append(newFuel)
                        }
                    }
                }
            }
            self.loadLabels()
        }
    }
    
    
}
