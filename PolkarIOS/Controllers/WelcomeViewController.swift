//
//  ViewController.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 20/10/2021.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    var cars: [Car] = []
    var carUID: String = ""
    var car: Car?
    //var events: [Event] = []
    var events: [String:Event] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        loadEventData()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        welcomeLabel.text = "Witaj \(Auth.auth().currentUser?.email ?? "")"
        
        navigationItem.hidesBackButton = true
        
        tableView.rowHeight = 150.0
        tableView.register(UINib(nibName: "CarCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
    }
    
    @IBAction func addCarPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.Segue.welcomeToAddCar, sender: self)
    }
    
    func loadData(){
        db.collection(K.Cars.colection).whereField(K.Cars.userUID, isEqualTo: Auth.auth().currentUser?.uid ?? "").order(by: K.Cars.time, descending: true).addSnapshotListener { querySnapshot, error in
            
            self.cars = []
            
            if let e = error {
                print("There was an issue retrieving data form firestore. \(e)")
            } else {
                if let snapshotDocument = querySnapshot?.documents {
                    for doc in snapshotDocument {
                        let data = doc.data()
                        if let UID = data[K.Cars.UID] as? String,
                           let brand = data[K.Cars.brand] as? String,
                           let model = data[K.Cars.model] as? String,
                           let mileage = data[K.Cars.mileage] as? Float,
                           let fuelType = data[K.Cars.fuelType] as? String,
                           let fuelTankCapacity = data[K.Cars.fuelTankCapacity] as? Float,
                           let engine = data[K.Cars.engine] as? String,
                           let body = data[K.Cars.body] as? String,
                           let insurance = data[K.Cars.insurance] as? String,
                           let service = data[K.Cars.service] as? String,
                           let average = data[K.Cars.averageFuelUsage] as? Float{
                            
                            let newCar = Car(UID: UID, brand: brand, model: model, mileage: mileage, fuelType: fuelType, fuelTankCapacity: fuelTankCapacity, engine: engine, body: body, insurance: insurance, service: service, average: average)
                            
                            self.cars.append(newCar)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WelcomeToCar" {
            let destinationVC = segue.destination as! CarViewController
            destinationVC.carUID = carUID
            destinationVC.car = car
        }
    }
    
    func loadEventData() {
        db.collection(K.Event.colection).whereField(K.Event.userUID, isEqualTo: Auth.auth().currentUser?.uid ?? "").whereField(K.Event.reminder, isEqualTo: "ture").order(by: K.Event.mileageReminder, descending: true).limit(to: 1).getDocuments { (querySnapshot, error) in
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
                            //self.events.append(newEvent)
                            
                            self.events.updateValue(newEvent, forKey: carUID)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
}

extension WelcomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! CarCell
        
        cell.carNameLabel.text = cars[indexPath.row].model
        
        //cell.carEventLabel.text = events[cars[indexPath.row].UID]?.type
        if indexPath.row == 0 {
            cell.carEventLabel.text = "Wymiana oleju za 1563km"
        } else {
            cell.carEventLabel.text = "Zaplanuj przegląd za 242 dni"
        }

        cell.carMileageLabel.text = String(cars[indexPath.row].mileage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        carUID = cars[indexPath.row].UID
        car = cars[indexPath.row]
        self.performSegue(withIdentifier: "WelcomeToCar", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}




