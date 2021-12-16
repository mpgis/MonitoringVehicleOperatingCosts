//
//  CarController.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 07/11/2021.
//

import UIKit
import Firebase
import FirebaseFirestore

class CarViewController: UIViewController {
    
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var insuranceLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    
    @IBOutlet weak var fuelsTableView: UITableView!
    @IBOutlet weak var eventsTableView: UITableView!
    
    var carUID: String = ""
    var car: Car?
    let db = Firestore.firestore()
    var fuels: [Fuel] = []
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fuelsTableView.dataSource = self
        fuelsTableView.delegate = self
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        
        fuelsTableView.register(UINib(nibName: "FuelCell", bundle: nil), forCellReuseIdentifier: "Fuel Cell")
        eventsTableView.rowHeight = 70.0
        eventsTableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "Event Cell")
        
        
        loadLabels()
        loadFuelsData()
        loadEventsData()
    }
    
    @IBAction func deleteCarPressed(_ sender: UIButton) {
        db.collection(K.Cars.colection).document(carUID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                self.deleteCarInUser()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func loadLabels(){
        let average = car?.average
        averageLabel.text = String(format: "%.2f", average!)
        insuranceLabel.text = car?.insurance
        serviceLabel.text = car?.service
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
    
    func loadFuelsData(){
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
                            self.fuels.append(newFuel)
                            
                            DispatchQueue.main.async {
                                self.fuelsTableView.reloadData()
                            }
                        }
                           
                    }
                }
            }
        }
    }
    
    func loadEventsData() {
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
                           let userUID = data[K.Event.userUID] as? String {
                         
                            let newEvent = Event(UID: UID, carUID: carUID, date: date, description: description, mileage: mileage, price: price, type: type, reminder: reminder, mileageReminder: mileageReminder, model: model, brand: brand, userUID: userUID)
                            self.events.append(newEvent)
                            
                            DispatchQueue.main.async {
                                self.eventsTableView.reloadData()
                            }
                        }
                    }
                }
            }
            self.carCostAverage()
        }
    }
    
    func carCostAverage() {
        if events.count > 1 {
            let mileage = events[0].mileage - events[events.count - 1].mileage
            var sum: Float = 0.0
            
            for event in events {
                sum += event.price
            }
            
            let average = sum / mileage * 1000
            costLabel.text = String(format: "%.1f", average)
        } else {
            costLabel.text = "0.0"
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CarToEdit" {
            let destinationVC = segue.destination as! EditCarViewController
            destinationVC.car = car
        }
        
        if segue.identifier == "CarToFuel" {
            let destinationVC = segue.destination as! FuelViewController
            destinationVC.car = car
        }
        
        if segue.identifier == "CarToEvent" {
            let destinationVC = segue.destination as! AddEventViewController
            destinationVC.car = car
        }
    }
    
}

extension CarViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == fuelsTableView {
            return fuels.count
        } else {
            return events.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == fuelsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Fuel Cell", for: indexPath) as! FuelCell
            
            cell.amountTextField.text = String(fuels[indexPath.row].amount)
            cell.averageTextField.text = String(format: "%.2f", fuels[indexPath.row].average)
            cell.sumTextField.text = String(fuels[indexPath.row].sum)
            if(fuels[indexPath.row].fullTank == true){
                cell.checkmarkImage.isHidden = false
            } else {
                cell.checkmarkImage.isHidden = true
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Event Cell", for: indexPath) as! EventCell
            
            cell.nameLabel.text = events[indexPath.row].brand + " " + events[indexPath.row].model
            cell.dateLabel.text = events[indexPath.row].date
            cell.mileageLabel.text = String(events[indexPath.row].mileage)
            cell.typeLabel.text = events[indexPath.row].type
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //carUID = cars[indexPath.row].UID
        //car = cars[indexPath.row]
        //self.performSegue(withIdentifier: "WelcomeToCar", sender: self)
    }
    
}
