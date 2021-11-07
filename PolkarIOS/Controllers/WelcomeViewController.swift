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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        tableView.dataSource = self
        welcomeLabel.text = "Witaj \(Auth.auth().currentUser?.email ?? "")"
        
        navigationItem.hidesBackButton = true
        
        tableView.rowHeight = 150.0
        tableView.register(UINib(nibName: "CarCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
    }

    @IBAction func logOutPressed(_ sender: UIButton) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
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
                           let mileage = data[K.Cars.mileage] as? String,
                           let fuelType = data[K.Cars.fuelType] as? String,
                           let fuelTankCapacity = data[K.Cars.fuelTankCapacity] as? String,
                           let engine = data[K.Cars.engine] as? String,
                           let body = data[K.Cars.body] as? String,
                           let insurance = data[K.Cars.insurance] as? String,
                           let service = data[K.Cars.service] as? String {
                            
                            let newCar = Car(UID: UID, brand: brand, model: model, mileage: mileage, fuelType: fuelType, fuelTankCapacity: fuelTankCapacity, engine: engine, body: body, insurance: insurance, service: service)
                            
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
    
}

extension WelcomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! CarCell
        
        cell.carNameLabel.text = cars[indexPath.row].model
        
        
        return cell
    }
    
    
}




