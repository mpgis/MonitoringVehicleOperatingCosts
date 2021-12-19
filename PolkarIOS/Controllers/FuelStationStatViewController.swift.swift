//
//  FuelStationStatViewController.swift.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 05/12/2021.
//

import UIKit
import Firebase

class FuelStationStatViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    var stations: [String] = ["Orlen", "BP", "Shell", "CircleK", "Amic", "Moya"]
    var fuelTypes: [String] = ["Benzyna", "Diesel", "LPG", "CNG"]
    var fuelStations: [FuelStation] = []
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "StationCell", bundle: nil), forCellReuseIdentifier: "Station Cell")
        
        fillStations()
        
        for station in stations {
            for fuelType in fuelTypes {
                loadData(station: station, fuelType: fuelType)
            }
        }

    }
    
    func loadData(station:String, fuelType:String) {
        var prices: [Float] = []

        db.collection(K.Fuel.colection).whereField(K.Fuel.station, isEqualTo: station).whereField(K.Fuel.fuelType, isEqualTo: fuelType).getDocuments { (querySnapshot, error) in
            if let e = error {
                print("There was an issue retrieving data form firestore. \(e)")
            } else {
                if let snapshotDocument = querySnapshot?.documents {
                    for doc in snapshotDocument {
                        let data = doc.data()
                        if let price = data[K.Fuel.price] as? Float {
                            prices.append(price)
                            print(station + " " + fuelType)
                        }
                    }
                    self.addData(prices: prices, station: station, fuelType: fuelType)
                }
            }
        }
    }
    
    func addData(prices: [Float], station:String, fuelType:String){
        for n in 0...fuelStations.count - 1 {
            if (fuelStations[n].name == station){
                var average: Float
                var sum: Float = 0.0
                for price in prices {
                    sum += price
                }
                
                if(prices.count != 0) {
                    average = sum / Float(prices.count)
                    
                    switch fuelType {
                    case "Benzyna":
                        fuelStations[n].pb = average
                        break
                    case "Diesel":
                        fuelStations[n].on = average
                        break
                    case "LPG":
                        fuelStations[n].lpg = average
                        break
                    case "CNG":
                        fuelStations[n].cng = average
                        break
                    default:
                        print("Error in switch")
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fillStations(){
        for station in stations {
            let newStation = FuelStation(name: station, pb: 0.0, on: 0.0, lpg: 0.0, cng: 0.0)
            fuelStations.append(newStation)
        }
    }
    
}

extension FuelStationStatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fuelStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Station Cell", for: indexPath) as! StationCell
        
        cell.nameLabel.text = fuelStations[indexPath.row].name
        cell.petrolLabel.text = String(format: "%.2f", fuelStations[indexPath.row].pb)
        cell.dieselLabel.text = String(format: "%.2f", fuelStations[indexPath.row].on)
        cell.lpgLabel.text = String(format: "%.2f", fuelStations[indexPath.row].lpg)
        cell.cngLabel.text = String(format: "%.2f", fuelStations[indexPath.row].cng)
        
        return cell
    }
}
