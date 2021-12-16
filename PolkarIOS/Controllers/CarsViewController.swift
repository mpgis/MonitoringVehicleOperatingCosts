//
//  CarsViewController.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 05/12/2021.
//

import UIKit
import Firebase

class CarsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    var cars: [Car] = []
    var carUID: String = ""
    var car: Car?
    var caller: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 150.0
        tableView.register(UINib(nibName: "CarCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
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
        if segue.identifier == "CarsToAddEvent" {
            let destinationVC = segue.destination as! AddEventViewController
            destinationVC.car = car
        } else if segue.identifier == "CarsToAddFuel" {
            let destinationVC = segue.destination as! FuelViewController
            destinationVC.car = car
        } else if segue.identifier == "CarsToCarStat" {
            let destinationVC = segue.destination as! CarStatViewController
            destinationVC.car = car
        }
    }

}

extension CarsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! CarCell
        
        cell.carNameLabel.text = cars[indexPath.row].model
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        carUID = cars[indexPath.row].UID
        car = cars[indexPath.row]
        self.performSegue(withIdentifier: caller!, sender: self)
    }
    
}
