//
//  GlobalStatViewController.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 11/12/2021.
//

import UIKit
import Firebase

class GlobalStatViewController: UIViewController {
    
    @IBOutlet weak var fixLabel: UILabel!
    @IBOutlet weak var partsReplacementLabel: UILabel!
    @IBOutlet weak var oilReplacementLabel: UILabel!
    @IBOutlet weak var otherLabel: UILabel!
    @IBOutlet weak var costAverageLabel: UILabel!
    
    @IBOutlet weak var pbAverageLabel: UILabel!
    @IBOutlet weak var onAverageLabel: UILabel!
    @IBOutlet weak var lpgAverageLabel: UILabel!
    @IBOutlet weak var cngAverageLabel: UILabel!
    
    
    var model: String?
    
    let db = Firestore.firestore()
    var events: [Event] = []
    var cars: [Car] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadEventData()
        loadCarsData()
    }
    
    func calculateEventsStats() {
        
        var fixSum: Float = 0.0
        var fixCount = 0
        var fixMileageMin: Float?
        var fixMileageMax: Float?
        var fixAverage: Float = 0.0
        
        var partsReplacementSum: Float = 0.0
        var partsReplacementCount = 0
        var partsReplacementMileageMin: Float?
        var partsReplacementMileageMax: Float?
        var partsReplacementAverage: Float = 0.0
        
        var oilReplacementSum: Float = 0.0
        var oilReplacementCount = 0
        var oilReplacementMileageMin: Float?
        var oilReplacementMileageMax: Float?
        var oilReplacementAverage: Float = 0.0
       
        var otherSum: Float = 0.0
        var otherCount = 0
        var otherMileageMin: Float?
        var otherMileageMax: Float?
        var otherAverage: Float = 0.0
        
        var globalCount: Float = 4.0
        
        for event in events {
            switch event.type {
            case "Naprawa":

                if let max = fixMileageMax {
                    if max < event.mileage {
                        fixMileageMax = event.mileage
                    }
                } else {
                    fixMileageMax = event.mileage
                }
                if let min = fixMileageMin {
                    if min > event.mileage {
                        fixMileageMin = event.mileage
                    }
                } else {
                    fixMileageMin = event.mileage
                }
                
                fixSum += event.price
                fixCount += 1
                
                break
            case "Wymiana czesci eksploatacyjnych":
                
                if let max = partsReplacementMileageMax {
                    if max < event.mileage {
                        partsReplacementMileageMax = event.mileage
                    }
                } else {
                    partsReplacementMileageMax = event.mileage
                }
                if let min = partsReplacementMileageMin {
                    if min > event.mileage {
                        partsReplacementMileageMin = event.mileage
                    }
                } else {
                    partsReplacementMileageMin = event.mileage
                }
                
                partsReplacementSum += event.price
                partsReplacementCount += 1
                break
            case "Wymiana oleji i filtrow":
                
                if let max = oilReplacementMileageMax {
                    if max < event.mileage {
                        oilReplacementMileageMax = event.mileage
                    }
                } else {
                    oilReplacementMileageMax = event.mileage
                }
                if let min = oilReplacementMileageMin {
                    if min > event.mileage {
                        oilReplacementMileageMin = event.mileage
                    }
                } else {
                    oilReplacementMileageMin = event.mileage
                }
                
                oilReplacementSum += event.price
                oilReplacementCount += 1
                break
            case "Inne":
                
                if let max = otherMileageMax {
                    if max < event.mileage {
                        otherMileageMax = event.mileage
                    }
                } else {
                    otherMileageMax = event.mileage
                }
                if let min = otherMileageMin {
                    if min > event.mileage {
                        otherMileageMin = event.mileage
                    }
                } else {
                    otherMileageMin = event.mileage
                }
                
                otherSum += event.price
                otherCount += 1
                break
            default:
                print("Error in eventsStats switch")
            }
        }
        
        if let max = fixMileageMax, let min = fixMileageMin {
            if max - min != 0 {
                fixAverage = fixSum / (max - min) * 1000
                fixLabel.text = String(fixAverage)
            } else {
                fixLabel.text = "0"
                globalCount -= 1
            }
        } else {
            fixLabel.text = "0"
            globalCount -= 1
        }
        
        if let max = partsReplacementMileageMax, let min = partsReplacementMileageMin {
            if max - min != 0 {
                partsReplacementAverage = partsReplacementSum / (max - min) * 1000
                partsReplacementLabel.text = String(partsReplacementAverage)
            } else {
                partsReplacementLabel.text = "0"
                globalCount -= 1
            }
        } else {
            partsReplacementLabel.text = "0"
            globalCount -= 1
        }
        
        if let max = oilReplacementMileageMax, let min = oilReplacementMileageMin {
            if max - min != 0 {
                oilReplacementAverage = oilReplacementSum / (max - min) * 1000
                oilReplacementLabel.text = String(oilReplacementAverage)
            } else {
                oilReplacementLabel.text = "0"
                globalCount -= 1
            }
        } else {
            oilReplacementLabel.text = "0"
            globalCount -= 1
        }
        
        if let max = otherMileageMax, let min = otherMileageMin {
            if max - min != 0 {
                otherAverage = otherSum / (max - min) * 1000
                otherLabel.text = String(otherAverage)
            } else {
                otherLabel.text = "0"
                globalCount -= 1
            }
        } else {
            otherLabel.text = "0"
            globalCount -= 1
        }
        
        if globalCount != 0 {
            costAverageLabel.text = String((fixAverage + partsReplacementAverage + oilReplacementAverage + otherAverage) / globalCount)
        } else {
            costAverageLabel.text = "0"
        }
        
    }
    
    func calculateFuelsStats() {
        var pbSum: Float = 0.0
        var pbCount: Float = 0.0
        var onSum: Float = 0.0
        var onCount: Float = 0.0
        var lpgSum: Float = 0.0
        var lpgCount: Float = 0.0
        var cngSum: Float = 0.0
        var cngCount: Float = 0.0
        
        
        for car in cars {
            switch car.fuelType {
            case "Benzyna":
                pbSum += car.average
                pbCount += 1
                break
            case "Diesel":
                onSum += car.average
                onCount += 1
                break
            case "LPG":
                lpgSum += car.average
                lpgCount += 1
                break
            case "CNG":
                cngSum += car.average
                cngCount += 1
                break
            default:
                print("Error in fuelsStat switch")
            }
        }
        
        if pbCount != 0 {
            pbAverageLabel.text = String(pbSum / pbCount)
        } else {
            pbAverageLabel.text = "0"
        }
        if onCount != 0 {
            onAverageLabel.text = String(onSum / onCount)
        } else {
            onAverageLabel.text = "0"
        }
        if lpgCount != 0 {
            lpgAverageLabel.text = String(lpgSum / lpgCount)
        } else {
            lpgAverageLabel.text = "0"
        }
        if cngCount != 0 {
            cngAverageLabel.text = String(cngSum / cngCount)
        } else {
            cngAverageLabel.text = "0"
        }
        
    }
    
    func loadEventData() {
        db.collection(K.Event.colection).whereField(K.Event.model, isEqualTo: model ?? "").order(by: K.Event.mileage, descending: true).getDocuments { (querySnapshot, error) in
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
                        }
                    }
                    self.calculateEventsStats()
                }
            }
        }
    }
    
    func loadCarsData() {
        db.collection(K.Cars.colection).whereField(K.Cars.model, isEqualTo: model ?? "").getDocuments { (querySnapshot, error) in
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
                        }
                    }
                    self.calculateFuelsStats()
                }
            }
        }
    }
    
}
